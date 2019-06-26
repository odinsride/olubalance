# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_timezone

  before_action :assign_navbar_content
  before_action :configure_permitted_parameters, if: :devise_controller?

  def assign_navbar_content
    @navbar_accounts = current_user.accounts if user_signed_in?
  end

  # disabling rubocop until I have time since this was copied from the interweb
  def custom_paginate_renderer # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    # Return nice pagination for materialize
    Class.new(WillPaginate::ActionView::LinkRenderer) do
      def container_attributes
        { class: 'pagination' }
      end

      def page_number(page)
        if page == current_page
          '<li class="ob-secondary z-depth-2 active">' + link(page, page, rel: rel_value(page)) + '</li>'
        else
          '<li class="waves-effect">' + link(page, page, rel: rel_value(page)) + '</li>'
        end
      end

      def previous_page
        num = @collection.current_page > 1 && @collection.current_page - 1
        previous_or_next_page(num, '<i class="material-icons ob-text-primary">chevron_left</i>')
      end

      def next_page
        num = @collection.current_page < total_pages && @collection.current_page + 1
        previous_or_next_page(num, '<i class="material-icons ob-text-primary">chevron_right</i>')
      end

      def previous_or_next_page(page, text)
        if page
          '<li class="waves-effect">' + link(text, page) + '</li>'
        else
          '<li class="waves-effect">' + text + '</li>'
        end
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) \
      { |u| u.permit(:first_name, :last_name, :timezone, :email, :password) }
    devise_parameter_sanitizer.permit(:account_update) \
      { |u| u.permit(:first_name, :last_name, :timezone, :email, :password, :current_password) }
  end

  private

  def set_timezone
    tz = current_user ? current_user.timezone : nil
    Time.zone = tz || ActiveSupport::TimeZone['UTC']
  end
end
