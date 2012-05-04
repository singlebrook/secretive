module Secrets
  class Loader
    class << self
      def environmentalize!(yaml_file, scope=nil)
        vars = YAML.load(File.open(yaml_file))
      
        convert_to_env_vars(vars)
        convert_to_env_vars(vars.fetch(scope)) if scope.present?
      end
    
      def for_heroku(yaml_file, scope=nil)
        vars = YAML.load(File.open(yaml_file))
      
        heroku_string = convert_vars_to_string(vars)
        heroku_string += convert_vars_to_string(vars.fetch(scope)) if scope.present?
        heroku_string
      end
    
      private
    
      def convert_to_env_vars(vars)
        return unless vars.present?
        
        vars.each do |key, value|
          ENV[key] = value unless value.respond_to?(:each) || value.nil?
        end
      end
    
      def convert_vars_to_string(vars)
        return unless vars.present?
        
        string = ""
        vars.each do |key, value|
          string.concat("#{key}=#{value} ") unless value.respond_to?(:each) || value.nil?
        end
        string
      end 
    end
  end
end