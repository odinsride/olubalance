class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!


  before_action :assign_navbar_content

  def assign_navbar_content
  	@navbar_accounts = current_user.accounts
  end

end
