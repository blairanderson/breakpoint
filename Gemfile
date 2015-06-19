source "https://rubygems.org"

ruby "2.2.2"

gem 'acts_as_tenant',       github: 'davekaro/acts_as_tenant'
gem 'annotate'
gem 'airbrake'
gem 'autoprefixer-rails'
gem 'bootstrap-sass'
gem 'bootstrap3-datetimepicker-rails'
gem 'coffee-rails', '~> 4.1.0'
gem 'delayed_job_active_record'
gem 'chronic'
gem 'destroyed_at'
gem 'devise'
gem 'devise-async'
gem 'email_validator'
gem 'flutie'
gem 'high_voltage'
gem 'icalendar',            github: 'icalendar/icalendar', branch: 'master'
gem 'i18n-tasks'
gem 'jquery-rails'
gem 'mechanize'
gem 'momentjs-rails'
gem 'newrelic_rpm', ">= 3.9.8"
gem 'normalize-rails', "~> 3.0.0"
gem 'paper_trail'
gem 'pundit'
gem 'pg'
gem 'postmark-rails'
gem 'rack-canonical-host'
gem 'rails', "4.2.1"
gem 'recipient_interceptor'
gem 'sass-rails', "~> 5.0"
gem 'sidekiq'
gem 'simple_form'
gem 'sinatra',              require: false
gem 'title'
gem 'uglifier'
gem 'unicorn'

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console'
  gem 'letter_opener_web', github: 'davekaro/letter_opener_web'
  gem 'quiet_assets'
  gem 'faker'
end

group :development, :test do
  gem 'awesome_print'
  gem 'bundler-audit', require: false
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.1.0'
end

group :test do
  gem 'capybara-webkit', '>= 1.2.0'
  gem 'database_cleaner'
  gem 'formulaic'
  gem 'launchy'
  gem 'shoulda-matchers', require: false
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'
end

group :staging, :production do
  gem 'rails_stdout_logging'
  gem 'rack-timeout'
end
