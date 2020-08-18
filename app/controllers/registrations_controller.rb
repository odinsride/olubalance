# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  private

  def check_captcha
    success = verify_recaptcha(action: 'registration', minimum_score: 0.5)
    checkbox_success = verify_recaptcha unless success
    if success || checkbox_success

    else
      if !success
        @show_checkbox_recaptcha = true
      end
      render 'new'
    end

    # unless verify_recaptcha
    #   self.resource = resource_class.new sign_up_params
    #   resource.validate # Look for any other validation errors besides reCAPTCHA
    #   set_minimum_password_length
    #   respond_with_navigational(resource) { render :new }
    # end
  end
end
