# frozen_string_literal: true

class Layout::Notifications::FlashComponent < ViewComponent::Base
  def initialize(type:, data:)
    @type = type
    @data = data
    @color_class = color_class
  end

  private

  def color_class
    case @type
    when 'success'
      'bg-primary-50 border-primary-400 text-primary-800'
    when 'error', 'alert'
      'bg-red-100 border-red-400 text-red-800'
    else
      'bg-indigo-100 border-indigo-400 text-indigo-800'
    end
  end
end
