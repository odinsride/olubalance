# frozen_string_literal: true

class Layout::SideBar::SideBarExpandComponent < ViewComponent::Base
  renders_one :icon
  renders_one :label

  def label_class
    return if icon?

    'pl-5'
  end
end
