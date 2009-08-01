module Voodoo
  module BasePage
    module ControllerClassMethods 
      def self.included(base)
        base.extend(self)
      end

      def voo_move_item(parent, model, options = {})
        define_method "move_#{model}" do 
          Object.const_get(model.to_s.camelize.to_sym).find(params[:id]).send(params[:method])
          instance_variable_set("@#{model.to_s.pluralize}", Object.const_get(parent.to_s.camelize.to_sym).first.send("#{model.to_s.pluralize.to_sym}"))
          respond_to do |wants|
            wants.html {
              unless options.include?(:template)
                render :partial => "#{model.to_s.pluralize}/#{model.to_s}", :collection => eval("@#{model.to_s.pluralize}")
              else
                render :partial => "#{options[:template]}", :collection => eval("@#{model.to_s.pluralize}")
              end
            }
          end
        end
      end
    end
  end
end

