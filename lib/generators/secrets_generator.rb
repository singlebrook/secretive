class SecretsGenerator < ::Rails::Generators::Base
  def create_secrets_file
    create_file("#{Rails.root}/config/secrets.yml")
  end
  
  def create_example_file
    create_file("#{Rails.root}/config/secrets.yml.example")
  end
  
  def gitignore_secrets_file
    append_to_file("#{Rails.root}/.gitignore") do
      "\n\n" + 
      "# Sensitive API and password information.\n" +
      "# Keep it secret. Keep it safe.\n" +
      "config/secrets.yml"
    end
  end
end