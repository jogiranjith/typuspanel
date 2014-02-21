# Module designed to work with `acts_as_list`.

require 'active_support/concern'

module Admin
  module ActsAsList

    extend ActiveSupport::Concern

    included do
      before_filter :get_object, :only => [:position]
      before_filter :check_resource_ownership, :only => [:position]
    end

    def position
      if %w(move_to_top move_higher move_lower move_to_bottom).include?(params[:go])
        @item.send(params[:go])
        notice = Typus::I18n.t("%{model} successfully updated.", :model => @resource.model_name.human)
        redirect_to :back, :notice => notice
      else
        not_allowed
      end
    end

  end
end
