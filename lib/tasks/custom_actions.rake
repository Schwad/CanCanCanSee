
namespace :cancancansee do

  desc 'List current abilities established.'
  task :abilities  do
    CanCanCanSee.establish_variable
    @current_slug_abilities = MY_GLOBAL_HOLDER_OF_ABILITY[Figaro.env.slug]

    @current_slug_abilities.each do |key, value|
      print "\n\n"
      print "Role: #{key}\n"
      value.each do |can, can_value|
        print "  #{can}\n"
        can_value = can_value.sort
        can_value.each do |can_value_element|
          print "    #{can_value_element}\n"
        end
      end
    end
  end

  desc 'Lists current abilities for all slugs'
  task :abilities_all_slugs  do
    @current_slug_abilities = MY_GLOBAL_HOLDER_OF_ABILITY

    @current_slug_abilities.each do |key, value|
      print "\n\n"
      print "Slug: #{key}\n\n"
      value.each do |role_key, role_value|
        print "\n\n"
        print "  Role: #{role_key}\n\n"
        role_value.each do |can, can_value|
          print "    #{can}\n"
          can_value = can_value.sort
          can_value.each do |can_value_element|
            print "      #{can_value_element}\n"
          end
        end
      end
    end
  end
end
