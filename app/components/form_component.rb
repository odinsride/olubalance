# frozen_string_literal: true

class FormComponent < ApplicationComponent
  def initialize(title:)
    super
    @title = title
  end

end
