# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  def self.collection_decorator_class
    PaginatingDecorator
  end

  def form_name
    new_record? ? "New" : "Edit"
  end

  def button_label
    new_record? ? "Create" : "Update"
  end
end
