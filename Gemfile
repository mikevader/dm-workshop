source 'https://rubygems.org'

# Use specific ruby version
ruby '2.2.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.5.1'
# Use bootstrap with sass
gem 'bootstrap-sass', '~> 3.3.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.4'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.1.0'

gem 'will_paginate', '~> 3.1.0'
gem 'bootstrap-will_paginate', '~> 0.0.10'
gem 'bootstrap-colorselector-rails'



# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.4.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.1', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.10'
# For the authorization
gem 'pundit', '~> 1.1.0'


gem 'faker', '~> 1.6.0'
gem 'carrierwave', '~> 0.10.0'
gem 'mini_magick', '~> 4.3.6'
gem 'fog', '~> 1.37.0'

gem 'nokogiri', '~> 1.6.7.1'
gem 'activerecord-session_store', '~> 0.1.2'

gem 'treetop', '~> 1.6.3'
gem 'net-ssh', '~> 3.0.1'


gem 'rails_admin', '~> 0.8.0'

gem 'acts-as-taggable-on', '~>3.5.0'
gem 'recaptcha', require: 'recaptcha/rails'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'mechanize'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.2'

  # Security check
  gem 'brakeman', require: false
  gem 'guard-brakeman', require: false
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'minitest-reporters', '~> 1.1.7'
  gem 'mini_backtrace',     '~> 0.1.3'
  gem 'guard'
  gem 'guard-minitest',     '~> 2.4.4'
  gem 'terminal-notifier-guard'
  gem 'nokogiri-diff'
end

group :production do
  gem 'pg',              '0.18.4'
  gem 'rails_12factor',  '0.0.3'
  gem 'puma',            '2.15.3'
end

