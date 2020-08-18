# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.6'

gem 'aws-sdk-s3', '~> 1.69.0'
gem 'devise', '~> 4.7.2'
gem 'draper', '~> 4.0.1'
gem 'faker', '~> 2.12.0'
gem 'figaro', '~> 1.2.0'
gem 'hiredis'
gem 'mini_magick', '~> 4.10.1'
gem 'pagy', '~> 3.8.2'
gem 'pg', '~> 1.2.3'
gem 'puma', '~> 4.3.5'
gem 'rails', '~> 6.0.3.2'
gem 'recaptcha'
gem 'redis', '>= 4.0', require: ['redis', 'redis/connection/hiredis']
gem 'stimulus_reflex', '~> 3.2.3'
gem 'webpacker', '~> 5.1.1'

group :development, :test do
  gem 'capybara'
  gem 'database_cleaner', '~> 1.8.5'
  gem 'factory_bot_rails', '~> 6.0.0'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rails-controller-testing', '~> 1.0.4'
  gem 'rspec-rails', '~> 4.0.1'
  gem 'shoulda-matchers', '~> 4.3.0'
  gem 'simplecov', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'listen'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
end
