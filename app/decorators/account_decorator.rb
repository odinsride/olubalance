class AccountDecorator < Draper::Decorator
  decorates_finders
  decorates_association :user
  delegate_all

  def last_four_formatted
    last_four.present? ? ' ( ... ' + last_four.to_s + ')' : nil
  end
end
