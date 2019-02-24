source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.0'

gem 'aws-sdk-s3'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'draper'
gem 'figaro'
gem 'font-awesome-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'material_icons'
gem 'materialize-form'
gem 'materialize-sass', '~> 0.100.2'
gem 'paperclip', '~> 6.0.0'
gem 'pg', '~> 1.1.4'
gem 'puma', '~> 3.12.0'
gem 'rails', '~> 5.2.1'
gem 'rails-ujs'
gem 'sassc', '~> 1.12.1'
gem 'sassc-rails', '~> 1.3.0'
gem 'simple_form'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'will_paginate', '~> 3.1.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'faker'
  gem 'selenium-webdriver'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', require: false
  gem 'solargraph'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
