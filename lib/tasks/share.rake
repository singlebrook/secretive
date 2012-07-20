require 'heroku'

namespace :secrets do
  desc 'Set environment vars defined in the production group of config/secrets.yml on the specified Heroku app.'
  task :share_with, :heroku_app do |task, args|
    raise "This task requires the heroku gem and it could not be found." unless defined?(Heroku)
    raise "Which heroku app do you want to share secrets with? Format is rake secrets:share[heroku_app]" unless args[:heroku_app].present?

    @heroku_app = args[:heroku_app]

    msg  = "This task will sync ALL ENVIRONMENT VARIABLES in the `#{@heroku_app}` app "
    msg += "with the values defined in the `production` group of config/secrets.yml. "
    msg += "Are you sure you want to proceed? (y/n)"
    puts msg

    confirmation = $stdin.gets.chomp
    raise unless confirmation == "y"

    sh "heroku config:add #{Secrets.for_heroku('production')} --app #{@heroku_app}"
  end
end
