module Secrets
  class Railtie < ::Rails::Railtie
    config.before_initialize do
      Secrets.environmentalize!(Secrets.file, Rails.env)
    end
    
    rake_tasks do
      load File.expand_path('../../tasks/share.rake', __FILE__)
    end
    
    generators do
      require File.expand_path('../../generators/secrets_generator', __FILE__)
    end
  end
end