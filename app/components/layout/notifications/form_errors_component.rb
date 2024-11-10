# frozen_string_literal: true

class Layout::Notifications::FormErrorsComponent < ViewComponent::Base
  def initialize(form_obj:)
    @form_obj = form_obj
  end
end
