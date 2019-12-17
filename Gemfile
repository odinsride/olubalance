# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.4'

gem 'aws-sdk-s3'
gem 'devise', '~> 4.6.2'
gem 'draper', '~> 3.1.0'
gem 'figaro'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'jquery-turbolinks'
# gem 'material_icons'
# gem 'materialize-form', '~> 1.0.8'
# gem 'materialize-sass', '~> 0.100.2'
gem 'mini_magick'
gem 'pg', '~> 1.1.4'
gem 'puma', '~> 4.0.1'
gem 'rails', '~> 5.2.3'
gem 'rails-ujs'
gem 'sassc'
gem 'sassc-rails'
# gem 'simple_form', '~> 4.1.0'
gem 'turbolinks'
gem 'uglifier'
gem 'will_paginate'
gem 'will_paginate-bulma'

group :development, :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 5.0.2'
  gem 'faker'
  gem 'pry-byebug', '~> 3.7.0'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.8.2'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
end
