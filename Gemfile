# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '3.0.0'

gem 'aws-sdk-s3', '~> 1.87.0'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'devise', '~> 4.7.3'
gem 'faker', '~> 2.15.1'
gem 'figaro', '~> 1.2.0'
gem 'image_processing'
gem 'invisible_captcha', '~> 1.1.0'
gem 'mini_magick', '~> 4.11.0'
gem 'pagy', '~> 3.10.0'
gem 'pg', '~> 1.2.3'
gem 'puma', '~> 5.1.1'
gem 'rails', '~> 6.1.1'
gem 'recaptcha', '~> 5.6.0'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.2.1'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
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
  gem 'letter_opener'
  gem 'listen'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]