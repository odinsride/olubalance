# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  decorates_finders
  decorates_association :account
  delegate_all
end
