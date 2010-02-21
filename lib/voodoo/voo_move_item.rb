module Voodoo
  module BasePage
    module ControllerClassMethods 
      def self.included(base)
        base.extend(self)
      end

      @@config = {:column => "position"}

      def voo_move_item(parent, model, options = {})
        @@config[:column] ||= options[:column]

        define_method "move_#{model}" do
          item = Object.const_get(model.to_s.camelize.to_sym).find(params[:id], :select => options[:select])
          if not (item.first? and params[:method] == "higher") and not (item.last? and params[:method] == "lower")
            item.send("move_#{params[:method]}".to_sym)
            if options.include?(:paginate)
              instance_variable_set("@#{model.to_s.pluralize}", Object.const_get(model.to_s.camelize.to_sym).paginate(:page => params[:page], :per_page => options[:paginate],
                    :conditions => ["#{parent.to_s}_id = ?", Object.const_get(parent.to_s.camelize.to_sym).first.id], :order => config[:column], :select => options[:select]))
            else
              instance_variable_set("@#{model.to_s.pluralize}", Object.const_get(parent.to_s.camelize.to_sym).first.send("#{model.to_s.pluralize.to_sym}"))
            end
            next_item = item.send("#{inverse_method(params[:method])}_item".to_sym)
          end
          respond_to do |wants|
              wants.js {
                  unless next_item.nil?
                    render :json  => {:item1 => {:id => item.id},
                                      :item2 => {:id => next_item.id}}
                  else
                    render :json => "nothing to do"
                  end
              }
          end
        end

        def inverse_method(method)
          return "higher" if method == "lower"
          return "lower" if method == "higher"
        end
      end
    end
  end
end

