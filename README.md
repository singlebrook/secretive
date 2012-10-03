# Secretive
### Secrets, secrets, are now fun. *(Exposed secrets hurt someone.)*

Secretive is a way to configure your application's ENV variables using a .yml file.

It includes Rails integration, including a generator and a task for sharing secrets with Heroku.

## Installation

Add this line to your application's Gemfile:

    gem 'secretive'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install secretive

## Usage

### Setting Up (With Rails)

Simply run `rails g secrets` to create and automatically .gitignore the required .yml files.

When starting your Rails application, top-level variables and any variables in a group with the same name as your Rails environment will become ENV variables.

For example, take following YAML file:

    TOP_SECRET: "This will self-destruct."

    development:
      SUPER_SECRET: "Jeremiah was a bullfrog."`
    production:
      SUPER_SECRET: "He was a good friend of mine."

In development:

    $ rails console -e development
      > ENV["SUPER_SECRET"]
      => "Jeremiah was a bullfrog."

      > ENV["TOP_SECRET"]
      => "This will self-destruct."

In production:

    $ rails console -e production
      > ENV["SUPER_SECRET"]
      => "He was a good friend of mine."

      > ENV["TOP_SECRET"]
      => "This will self-destruct."

### Setting Up (Without Rails)

If not using Rails, create a `config/secrets.yml` file (or whatever you want to call it) and call `Secretive.environmentalize!` somewhere in your application.

### Customizing

You can choose which file to use as your secrets file by setting `Secretive.file = "../path/to/myfile"` before calling `Secretive.environmentalize!`.

You can also pass `Secretive.environmentalize!` a scope. Top-level variables will always be loaded.

For example, take following YAML file:

    TOP_SECRET: "This will self-destruct."

    superheroes:
      BEST_HERO: "Harvey Birdman"`
    supervillains:
      BEST_VILLAIN: "Mentok, Mind-Taker"

After calling `Secretive.environmentalize!("superheroes")`:

    $ irb
      > ENV["BEST_HERO"]
      => "Harvey Birdman"

      > ENV["TOP_SECRET"]
      => "This will self-destruct."

      > ENV["BEST_VILLAIN"]
      => nil

## Sharing with Heroku

Secretive comes with a rake task for sharing secrets with Heroku.

Run `rake secretive:share_with[yourapp]` to convert all values in the `production` scope of your .yml file into ENV variables in the Heroku app.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request