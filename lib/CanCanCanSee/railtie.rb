require 'cancancansee'
require 'rails'

module CanCanCanSee
  class Railtie < Rails::Railtie
    railtie_name :cancancansee

    rake_tasks do
      load 'tasks/custom_actions.rake'
    end
  end
end
