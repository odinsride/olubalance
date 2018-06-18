class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  


  before_action :assign_navbar_content

  def assign_navbar_content
  	if user_signed_in?
  		@navbar_accounts = current_user.accounts
  	end
  end

  def custom_paginate_renderer
      # Return nice pagination for materialize
      Class.new(WillPaginate::ActionView::LinkRenderer) do
      def container_attributes
        {class: "pagination"}
      end

      def page_number(page)
        if page == current_page
          "<li class=\"ob-secondary z-depth-2 active\">"+link(page, page, rel: rel_value(page))+"</li>"
        else
          "<li class=\"waves-effect\">"+link(page, page, rel: rel_value(page))+"</li>"
        end
      end

      def previous_page
        num = @collection.current_page > 1 && @collection.current_page - 1
        previous_or_next_page(num, "<i class=\"material-icons ob-text-secondary\">chevron_left</i>")
      end

      def next_page
        num = @collection.current_page < total_pages && @collection.current_page + 1
        previous_or_next_page(num, "<i class=\"material-icons ob-text-secondary\">chevron_right</i>")
      end

      def previous_or_next_page(page, text)
        if page
          "<li class=\"waves-effect\">"+link(text, page)+"</li>"
        else
          "<li class=\"waves-effect\">"+text+"</li>"
        end
      end
  end
end

end
