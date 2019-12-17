# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'test@gmail.com' }
    password { 'topsecret' }
    password_confirmation { 'topsecret' }
    first_name { 'John' }
    last_name { 'Doe' }
    timezone { 'Eastern Time (US & Canada)' }
  end
end
