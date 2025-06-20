source 'https://rubygems.org'

# Use specific ruby version
ruby '3.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.2.0'
# Use bootstrap with sass
gem 'bootstrap', '~> 5.3.3'
# Use SCSS for stylesheets
gem 'sassc-rails', '~> 2.1.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 5.0.0'

# Simple API to perform paginated queries
gem 'pagy', '~> 9.0'
# Provides bootstrap-colorselector library
gem 'bootstrap-colorselector-rails', '~> 0.1.0'
# Autocomplete field
# gem 'rails-jquery-autocomplete', '~> 1.0.3'

gem 'redcarpet', '~> 3.3'

gem 'bootsnap', '~> 1.16', require: false

gem 'stimulus-rails', '~> 1.2'
gem 'sprockets-rails', '~> 3.4'
gem "importmap-rails"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbo-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 2.6.1', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.11'
# For the authorization
gem 'pundit', '~> 2.5.0'

# Use Data::Faker from perl to easily generate fake test data
gem 'faker', '~> 3.0'

# Upload files to Rails and map them to ORM frameworks
gem 'carrierwave', '~> 3.1.0'
# Manipulate images via ImageMagick or GraphicsMagick
gem 'mini_magick', '~> 5.0'
# Cloud service library which supports most of cloud providers
gem 'fog-aws', '~> 3.31.0'

# Producing and parsing XML used for import/export of cards
gem 'nokogiri', '~> 1.15'
# Store session data in active records aka database
gem 'activerecord-session_store', '~> 2.2.0'

# Use for easy parsing the search expression
gem 'treetop', '~> 1.6.12'
gem 'net-ssh', '~> 7.3.0'

# Create general purpose data admin interface
gem 'remotipart', '~> 1.3'
# gem 'rails_admin', '~> 3.1.2'
gem 'json', '~> 2.12.0'

# Tagging library for used on any kind of object
gem 'acts-as-taggable-on', '~> 12.0.0'
# Ordering library to order traits, actions, etc on monster and other cards
gem 'acts_as_list', '~> 1.2.0'
# Google re-captcha for sign-up process
gem 'recaptcha', '~> 5.19.0', require: 'recaptcha/rails'

# Ruby web server built for concurrency and performance
gem 'puma', '~> 6.6.0'

group :development do
  # Triggers live-reload any time guard is executed
  gem 'guard-livereload', '~> 2.4', require: false

  # Automating interaction with websites. Used for scraping dndspells.com for spells.
  gem 'mechanize', '~> 2.7'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 4.2.1'

  # Security check
  gem 'brakeman', '>= 6.0.1', require: false
  # Extension for guard to natively support brakeman
  gem 'guard-brakeman', '>= 0.8.6', require: false

  # RuboCop
  gem 'rubocop', '~> 1.56', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-minitest', require: false

  gem 'bundler-audit', '~> 0.9.1'
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '~> 2.0'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'debug', '~> 1.9', platforms: %i[mri mingw x64_mingw]

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '>= 2.0'


  gem 'rails-controller-testing'

  gem 'minitest-ci'
end

group :test do
  # Modify output of minitest
  gem 'minitest-reporters', '~> 1.1'
  # Adds support of ActiveRecord::backtrace_cleaner in minitest framework
  gem 'mini_backtrace',     '~> 0.1'
  # File system change tracker used for executing tests of changed files
  gem 'guard',              '~> 2.13'
  # Extension for guard to run tests with minitest framework
  gem 'guard-minitest',     '~> 2.4'
  # Extension for guard to send user notification on OSX
  gem 'terminal-notifier-guard', '~> 1.7'
  # Extension for nokogiri to calculate differences between two XML documents
  gem 'nokogiri-diff', '~> 0.2'
  # Performance test for optimizing cards display
  #gem 'rails-perftest'
  #gem 'ruby-prof'
  gem 'simplecov'
  gem 'simplecov-lcov'
  gem 'simplecov_json_formatter'
end

group :production do
  # Ruby interface for PostgreSQL database
  gem 'pg',                     '1.5.9'
  gem 'rails_12factor',         '0.0.3'
  gem 'rails_stdout_logging',   '0.0.5'
end
