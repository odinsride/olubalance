module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups
    module Icons
      # Name of the component method
      def icon(wrapper_options = nil)
        @icon ||= begin
          options[:icon].to_s.html_safe if options[:icon].present?
        end
      end

      # Used when the icon is optional
      def has_icon?
        icon.present?
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Icons)