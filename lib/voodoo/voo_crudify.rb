module Voodoo
  module BasePage
    module ControllerClassMethods
      def self.included(base)
        base.extend(self)
      end

      def voo_crudify(model, options = {})
        module_eval %(
          before_filter :find_#{model}, :only => %w(edit update show destroy)

          def index
            @#{model.pluralize} = #{model.camelize}.paginate :page => params[:page], :select => 'id, title, updated_at, position, #{options[:container]}_id'
          end

          def show
          end

          def new
            @#{model} = #{model.camelize}.new
          end

          def edit
          end

          def create
            @#{model} = #{model.camelize}.new(params[:#{model}])
            @#{model}.#{options[:container]} = #{options[:container].camelize}.first(:select => 'id')

            if @#{model}.save
              flash[:notice] = '#{model.camelize} was successfully created.'
              redirect_to [:admin, @#{model}]
            else
              render :action => 'new'
            end
          end

          def update
            if @#{model}.update_attributes(params[:#{model}])
              flash[:notice] = '#{model.camelize} was successfully updated.'
              redirect_to [:admin, @#{model}]
            else
              render :action => 'edit'
            end
          end

          def destroy
            @#{model}.destroy
            redirect_to admin_#{model.pluralize}_url
          end

          private

          def find_#{model}
            @#{model} = #{model.camelize}.find(params[:id])
          end
        )
      end
    end
  end
end

