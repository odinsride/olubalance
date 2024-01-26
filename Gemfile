# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '3.3.0'

gem 'aws-sdk-s3'
gem 'bootsnap', require: false
gem 'cssbundling-rails'
gem 'devise', '~> 4.9.0'
gem 'draper', '~> 4.0.2'
gem 'faker'
gem 'figaro'
gem 'hiredis'
gem 'image_processing', '~> 1.12.2'
gem 'invisible_captcha'
gem 'jsbundling-rails'
gem 'mini_magick', '~> 4.12.0'
gem 'pagy', '~> 6'
gem 'pg', '~> 1.5.4'
gem 'puma', '~> 6.4.2'
gem 'rails', '~> 7.1'
gem 'recaptcha'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
# gem 'redis', '~> 4.4.0', require: ['redis', 'redis/connection/hiredis']


group :development, :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webdrivers'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'letter_opener'
  gem 'listen'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
end
