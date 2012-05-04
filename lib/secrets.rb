require 'active_support/all'
require 'secrets/version'
require 'secrets/loader'
require 'secrets/railtie' if defined?(Rails)

module Secrets
  class << self
    def file
      @@file ||= 'config/secrets.yml'
    end
    
    def file=(file)
      @@file = file
    end
  
    def configure
      yield self
    end
  
    def environmentalize!(scope=nil)
      Loader.environmentalize!(self.file, scope)
    end
    
    def for_heroku(scope=nil)
      Loader.for_heroku(self.file, scope)
    end
  end
end

