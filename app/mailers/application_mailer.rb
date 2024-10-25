# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "accounts@olubalance.com"
  layout "mailer"
end
