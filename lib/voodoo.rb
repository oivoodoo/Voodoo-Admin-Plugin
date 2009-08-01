require 'voodoo/voo_base_page'
require 'voodoo/voo_move_item'

if Object.const_defined?("ActiveRecord")
  ActionController::Base.send(:include, Voodoo::BasePage::ControllerClassMethods)
end

