# frozen_string_literal: true

module ApplicationHelper
  include CurrencyHelper
  # Conditionally joins a set of CSS class names into a single string
  #
  # @param css_map [Hash] a mapping of CSS class names to boolean values
  # @return [String] a combined string of CSS classes where the value was true
  def class_string(css_map)
    classes = []

    css_map.each do |css, bool|
      classes << css if bool
    end

    classes.join(" ")
  end

  # Devise Helpers
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # friendly datetime
  def friendly_datetime(date)
    date.in_time_zone("Eastern Time (US & Canada)").strftime('%b %d, %Y @ %I:%M %p %Z')
  end

  # friendly date
  def friendly_date(date)
    date.strftime('%b %d, %Y')
  end

  # formatted date
  def formatted_date(date)
    date.strftime('%m/%d/%Y')
  end

  # display filesize in MB
  def filesize(bytes)
    number_to_human_size(bytes, precision: 2)
  end

  # render file icon based on content type
  def file_icon(content_type)
    case content_type
    when 'application/pdf'
      'bi-file-pdf-fill text-danger'
    when 'application/msword' || 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      'bi-file-word-fill text-info'
    when 'application/vnd.ms-excel' || 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      'bi-file-excel-fill text-success'
    when 'text/csv'
      'bi-file-spreadsheet-fill text-secondary'
    else
      'bi-file-text-fill text-secondary'
    end
  end

  # display a city/state combo as a single field
  def location(city, state)
    [city, state].reject(&:blank?).join(', ')
  end
end
