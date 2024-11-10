# frozen_string_literal: true

class Layout::SideBar::SideBarLinkComponent < ViewComponent::Base
  renders_one :icon
  renders_one :label
  renders_one :url

  def label_class
    return if icon?

    'pl-5'
  end

  def link
    return url if url?

    '#'
  end
end
