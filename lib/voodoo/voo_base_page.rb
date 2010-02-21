module Voodoo
  module BasePage
    module ControllerClassMethods
      def self.included(base)
        base.extend(self)
      end

      # options:
      # contains collection hash value for additional page rendering items.
      def voo_base_pages(*models)
        models.each do |model|
          voo_base_page(model, {})
        end
      end

      def voo_base_page(model, options)
        define_method "edit_#{model}" do
          instance_value_first(model)
          instance_collection(options[:collection])
        end
        define_method "update_#{model}" do
          value = instance_value_first(model)
          instance_collection(options[:collection])
          if value.update_attributes(params[model]) then
            redirect_to :action => "edit_#{model}" 
          else
            render :action => "edit_#{model}"
          end
        end
      end

    protected
      def instance_value_first(model)
        value = Object.const_get(model.to_s.camelize.to_sym).first
        instance_variable_set("@#{model.to_s}", value)
        value
      end

      def instance_value_all(model)
        value = Object.const_get(model.to_s.camelize.to_sym).all
        instance_variable_set("@#{model.to_s.pluralize}", value)
        value
      end

      def instance_collection(collection)
        unless collection.nil?
          collection.each do |value|
            instance_value_all(value)
          end
        end
      end
    end
  end
end
