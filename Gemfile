source 'https://rubygems.org'

# Use specific ruby version
ruby '2.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0'
# Use bootstrap with sass
gem 'bootstrap-sass', '~> 3.3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2.1'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.3.1'
gem 'jquery-ui-rails', '~> 5.0.5'

# Simple API to perform paginated queries
gem 'will_paginate', '~> 3.1.0'
# Extends will_paginate to provide correct styling for bootstrap
gem 'bootstrap-will_paginate', '~> 0.0.10'
# Provides bootstrap-colorselector library
gem 'bootstrap-colorselector-rails', '~> 0.1.0'
# Autocomplete field
gem 'rails-jquery-autocomplete', '~> 1.0.3'

gem 'redcarpet', '~> 3.3'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.0.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.6.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.1', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.11'
# For the authorization
gem 'pundit', '~> 1.1.0'

# Use Data::Faker from perl to easily generate fake test data
gem 'faker', '~> 1.7.2'

# Upload files to Rails and map them to ORM frameworks
gem 'carrierwave', '~> 1.0'
# Manipulate images via ImageMagick or GraphicsMagick
gem 'mini_magick', '~> 4.3'
# Cloud service library which supports most of cloud providers
gem 'fog', '~> 1.37'

# Producing and parsing XML used for import/export of cards
gem 'nokogiri', '~> 1.7.0'
# Store session data in active records aka database
gem 'activerecord-session_store', '~> 1.0.0'

# Use for easy parsing the search expression
gem 'treetop', '~> 1.6.3'
gem 'net-ssh', '~> 4.1.0'

# Create general purpose data admin interface
gem 'remotipart', github: 'mshibuya/remotipart'
gem 'rails_admin', '~> 1.1.1'

# Tagging library for used on any kind of object
gem 'acts-as-taggable-on', '~> 4.0.0'
# Ordering library to order traits, actions, etc on monster and other cards
gem 'acts_as_list', '~> 0.9.2'
# Google re-captcha for sign-up process
gem 'recaptcha', '~> 4.1.0', require: 'recaptcha/rails'

# Ruby web server built for concurrency and performance
gem 'puma', '~> 3.8.2'

group :development do
  # Triggers live-reload any time guard is executed
  gem 'guard-livereload', '~> 2.4', require: false

  # Automating interaction with websites. Used for scraping dndspells.com for spells.
  gem 'mechanize', '~> 2.7'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.3'

  # Security check
  gem 'brakeman', '>= 3.2.1', require: false
  # Extension for guard to natively support brakeman
  gem 'guard-brakeman', '>= 0.8.3', require: false

  # RuboCop
  gem 'rubocop', require: false
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '>= 1.3'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '>= 9.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '>= 2.0'


  gem 'rails-controller-testing'
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
end

group :production do
  # Ruby interface for PostgreSQL database
  gem 'pg',                     '0.18.4'
  gem 'rails_12factor',         '0.0.3'
  gem 'rails_stdout_logging',   '0.0.5'
end

