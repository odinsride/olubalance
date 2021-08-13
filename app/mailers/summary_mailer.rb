class SummaryMailer < ApplicationMailer
  def new_summary_email
    @summary = params[:summary]
    @current_user = params[:current_user]
    mail(to: params[:to], subject: "olubalance " + Time.now.strftime("%m/%d/%Y"))
  end

  def current_user
    @current_user
  end
end
