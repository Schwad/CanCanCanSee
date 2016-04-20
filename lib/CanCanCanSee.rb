require "CanCanCanSee/version"

module CanCanCanSee
  require 'CanCanCanSee/railtie' if defined?(Rails)

  MY_GLOBAL_HOLDER_OF_ABILITY = Hash.new

  def self.initiate_gem

    configuration_file = File.read('config/initializers/cancancansee.rb')


    if configuration_file.include?("single")

      my_file = File.read('app/models/ability.rb') # for single
      read_file(my_file)

    elsif configuration_file.include?("multiple")

      my_arr = []

      Dir.foreach('lib/ability_slugs') do |item|
       if item == "." || item == ".."
       else
         my_file = File.read("lib/ability_slugs/#{item}")
         #formatting keeps the helper file from being read here
         if my_file[0..6] == 'require'
         else
           my_arr << my_file
         end
       end
     end

       my_arr.each do |file|
         #MULTIPLES FILES WILL NEED TO BE FORMATTED WITH SLUG IN DEF MY_SLUG_ABILITY
         check_slug = /def (.*)_ability/.match(file)[1]
         read_file(file, check_slug)
       end
     end

  end

  def self.read_file(file, check_slug=nil)


    @current_file = file

    #capture in between text
      chunk_start = /when/ =~ @current_file
         #=> 119
       chunk_end = /when/ =~ @current_file[(chunk_start + 1)..-1]
         #=> 2554
      role_text = @current_file[chunk_start..chunk_end]

    #capture all roles
      all_text = Hash.new
      counter = 0
      roles = @current_file.scan(/when(.*)($|[ do])/)
      roles.map! { |item| item.to_s.gsub(/[^0-9a-z ]/i, '') }
      roles.map! { |item| item[1..-2]}

      role_count = roles.length
      chunk_start = /when/ =~ @current_file
      chunk_end = /when/ =~ @current_file[(chunk_start + 1)..-1]
      all_text[roles[counter]] = @current_file[chunk_start..chunk_end]
      counter += 1
      while counter < role_count
        chunk_start = chunk_end + 1
        #broke here
        chunk_end = ((/when/ =~ @current_file[(chunk_start + 1)..-1]) + chunk_start)
        all_text[roles[counter]] = @current_file[chunk_start..chunk_end]

        counter += 1
      end
      #BREAKING NOT PICKING UP REGISTRAR BEFORE HERE
    #capture text of ability
      # cannot_abilities = all_text[[" 'Assistant Registrar'"]].scan(/cannot(.*)($|[ do])/)
        #=> [[" :create_csr, Vessel do |vessel|"], [" [:create, :destroy, :update], [SpecificCertificate, PortStateControl, Certificate, Violation,"], [" [:create, :destroy], Document do |d|"], [" :update, Document do |d|"], [" [:create], [GeneratedCertificates::GeneratedCertificate] do |b|"], [" :read, ExternalNotification do |e|"], [" :manual_verified, Vessel do |e|"], [" [:update], SpecificCertificate do |e|"], [" :manage_inspection_resources, Inspection do |inspection|"], [" [:update, :destroy], Vessel do |v|"], [" [:create], MinimumSafeManning do |msm|"], [" [:update], MinimumSafeManning do |msm|"], [" [:create], MlcShipowner do |ms|"], [" [:update, :destroy], MlcShipowner do |ms|"], [" :update_classification_society, Vessel"], [" :upload_original, [GeneratedCertificates::MlcCertificate, GeneratedCertificates::DocOfComplianceCertificate] do |c|"], [" :destroy, [GeneratedCertificates::MlcCertificate, GeneratedCertificates::DmlcCertificate] do |c|"]]
        # can_abilities = all_text[[" 'Assistant Registrar'"]].scan(/can (.*)($|[ do])/)
        #=> [[" :manage, :all"], [" :change_registry, Registry"], ["not :create_csr, Vessel do |vessel|"], ["not [:create, :destroy, :update], [SpecificCertificate, PortStateControl, Certificate, Violation,"], ["not [:create, :destroy], Document do |d|"], ["not :update, Document do |d|"], ["not [:create], [GeneratedCertificates::GeneratedCertificate] do |b|"], ["not :read, ExternalNotification do |e|"], ["not :manual_verified, Vessel do |e|"], ["not [:update], SpecificCertificate do |e|"], [" :manage, Registry do |r|"], [" :manage, [Inspection] do |res|"], ["not :manage_inspection_resources, Inspection do |inspection|"], [" :print_history, Vessel"], ["not [:update, :destroy], Vessel do |v|"], ["not [:create], MinimumSafeManning do |msm|"], ["not [:update], MinimumSafeManning do |msm|"], ["not [:create], MlcShipowner do |ms|"], ["not [:update, :destroy], MlcShipowner do |ms|"], ["not :update_classification_society, Vessel"], ["not :upload_original, [GeneratedCertificates::MlcCertificate, GeneratedCertificates::DocOfComplianceCertificate] do |c|"], ["not :destroy, [GeneratedCertificates::MlcCertificate, GeneratedCertificates::DmlcCertificate] do |c|"]]
    #store in hash with array in can, array in cannot, array in an array if has condition in text.

      new_counter = 0
    if check_slug == nil

      while new_counter < roles.length
        MY_GLOBAL_HOLDER_OF_ABILITY[roles[new_counter]] = Hash.new

        array_of_can = []

        #establish can
        can_abilities = all_text[roles[new_counter]].scan(/can (.*)\n/)

        can_abilities.each do |can_ability|
          can_ability = can_ability[0]
          array_of_can << can_ability.gsub(/[^0-9a-z ]/i, '')
        end

        MY_GLOBAL_HOLDER_OF_ABILITY[roles[new_counter]]["can"] = array_of_can
        array_of_cannot = []

        #establish cannot
        cannot_abilities = all_text[roles[new_counter]].scan(/cannot (.*)\n/)

        cannot_abilities.each do |cannot_ability|
          cannot_ability = cannot_ability[0]
          array_of_cannot << cannot_ability.gsub(/[^0-9a-z ]/i, '')
        end

        MY_GLOBAL_HOLDER_OF_ABILITY[roles[new_counter]]["cannot"] = array_of_cannot


        new_counter += 1

      end
    else

      MY_GLOBAL_HOLDER_OF_ABILITY[check_slug] = Hash.new

      while new_counter < roles.length

        MY_GLOBAL_HOLDER_OF_ABILITY[check_slug][roles[new_counter]] = Hash.new

        array_of_can = []

        #establish can
        can_abilities = all_text[roles[new_counter]].scan(/can (.*)($|[ do])/)

        can_abilities.each do |can_ability|
          can_ability = can_ability[0]
          if can_ability.include?(" do ")
            can_ability =  "#{/(.*) do/.match(can_ability)[1]} WITH BLOCK"
          end
          array_of_can << can_ability.gsub(/[^0-9a-z ]/i, '')
        end

        MY_GLOBAL_HOLDER_OF_ABILITY[check_slug][roles[new_counter]]["can"] = array_of_can
        array_of_cannot = []

        #establish cannot
        cannot_abilities = all_text[roles[new_counter]].scan(/cannot(.*)($|[ do])/)

        cannot_abilities.each do |cannot_ability|
          cannot_ability = cannot_ability[0]
          if cannot_ability.include?("do")
            cannot_ability =  "#{/(.*) do/.match(cannot_ability)[1]} WITH BLOCK"
          end
          array_of_cannot << cannot_ability.gsub(/[^0-9a-z ]/i, '')
        end

        MY_GLOBAL_HOLDER_OF_ABILITY[check_slug][roles[new_counter]]["cannot"] = array_of_cannot


        new_counter += 1

      end
    end
  end

  #public methods

  def self.all_roles(desired_slug=nil)
    initiate_gem
    return MY_GLOBAL_HOLDER_OF_ABILITY[desired_slug].keys

  end

  def self.establish_variable
    initiate_gem

  end

  def self.all_abilities(desired_slug="all")
    initiate_gem
    if desired_slug == "all"
      return MY_GLOBAL_HOLDER_OF_ABILITY
    else
      return MY_GLOBAL_HOLDER_OF_ABILITY[desired_slug]
    end
  end

end
