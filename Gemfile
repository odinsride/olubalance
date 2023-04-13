# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '3.0.1'

gem 'aws-sdk-s3', '~> 1.87.0'
gem 'bootsnap', require: false
gem 'cssbundling-rails'
gem 'devise', '~> 4.7.3'
gem 'draper', '~> 4.0.1'
gem 'faker', '~> 2.15.1'
gem 'figaro', '~> 1.2.0'
gem 'hiredis', '~> 0.6.3'
gem 'image_processing'
gem 'invisible_captcha', '~> 1.1.0'
gem 'mini_magick', '~> 4.11.0'
gem 'jsbundling-rails'
gem 'pagy', '~> 3.10.0'
gem 'pg', '~> 1.2.3'
gem 'puma', '~> 5.6.4'
gem 'rails', '~> 6.1.0'
gem 'recaptcha', '~> 5.6.0'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
# gem 'redis', '~> 4.4.0', require: ['redis', 'redis/connection/hiredis']


group :development, :test do
  gem 'capybara'
  gem 'database_cleaner', '~> 1.8.5'
  gem 'factory_bot_rails', '~> 6.1.0'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rails-controller-testing', '~> 1.0.5'
  gem 'rspec-rails', '~> 4.0.2'
  gem 'shoulda-matchers', '~> 4.4.1'
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
