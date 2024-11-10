# frozen_string_literal: true

class Layout::ReturnLink::ReturnLinkComponent < ViewComponent::Base
  def initialize(return_link_text:, return_link_path:)
    @return_link_text = return_link_text
    @return_link_path = return_link_path
  end
end
