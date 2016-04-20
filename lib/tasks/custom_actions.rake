task abilities: :environment  do

  CanCanCanSee.establish_variable
  @current_slug_abilities = MY_GLOBAL_HOLDER_OF_ABILITY[Figaro.env.slug]

  @current_slug_abilities.each do |key, value|
    print "Role: #{key}:\n\n"
    value.each do |can, can_value|
      print "  #{can}\n"
      can_value = can_value.sort
      can_value.each do |can_value_element|
        print "  #{can_value_element}"
      end
    end
  end
end

task abilities_all_slugs: :environment  do
  @current_slug_abilities = MY_GLOBAL_HOLDER_OF_ABILITY[Figaro.env.slug]

  @current_slug_abilities.each do |key, value|
    print "Slug: #{key}\n\n"
    value.each do |role_key, role_value|
      print "  Role: #{role_key}:\n\n"
      role_value.each do |can, can_value|
        print "  #{can}\n"
        can_value = can_value.sort
        can_value.each do |can_value_element|
          print "  #{can_value_element}\n"
        end
      end
    end
  end

end
