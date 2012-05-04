module Secrets
  class Loader
    def self.environmentalize!(yaml_file, scope=nil)
      vars = YAML.load(File.open(yaml_file))
      
      convert_to_env_vars(vars)
      convert_to_env_vars(vars.fetch(scope)) if scope.present?
    end
    
    def self.for_heroku(yaml_file, scope=nil)
      vars = YAML.load(File.open(yaml_file))
      
      heroku_string = convert_vars_to_string(vars)
      heroku_string += convert_vars_to_string(vars.fetch(scope)) if scope.present?
      heroku_string
    end
    
    private
    
    def self.convert_to_env_vars(vars)
      vars.each do |key, value|
        ENV[key] = value unless value.respond_to?(:each)
      end
    end
    
    def self.convert_vars_to_string(vars)
      string = ""
      vars.each do |key, value|
        string.concat("#{key}=#{value} ") unless value.respond_to?(:each)
      end
      string
    end 
  end
end