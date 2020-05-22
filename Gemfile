# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.6'

gem 'aws-sdk-s3', '~> 1.60.0'
gem 'devise', '~> 4.7.1'
gem 'draper', '~> 3.1.0'
gem 'figaro', '~> 1.1.1'
gem 'font-awesome-rails', '~> 4.7.0.5'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'mini_magick', '~> 4.9.5'
gem 'pagy', '~> 3.7.1'
gem 'pg', '~> 1.2.3'
gem 'puma', '~> 4.3.5'
gem 'rails', '~> 6.0.2.2'
gem 'rails-ujs', '~> 0.1.0'
gem 'sassc', '~> 2.2.1'
gem 'sassc-rails', '~> 2.1.2'
gem 'turbolinks', '~> 5.2.1'
gem 'uglifier', '~> 4.2.0'
gem 'webpacker', '~> 4.2.2'

group :development, :test do
  gem 'capybara'
  gem 'database_cleaner', '~> 1.7.0'
  gem 'factory_bot_rails', '~> 5.1.1'
  gem 'faker', '~> 2.9.0'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rails-controller-testing', '~> 1.0.4'
  gem 'rspec-rails', '~> 3.9.0'
  gem 'shoulda-matchers', '~> 4.1.2'
  gem 'simplecov', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'spring'
  gem 'spring-watcher-listen'
end
