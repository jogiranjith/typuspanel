require 'active_support/concern'

module Admin
  module Headless

    extend ActiveSupport::Concern

    included do
      helper_method :headless_mode?
      layout :headless_layout
    end

    def headless_layout
      headless_mode? ? "admin/headless" : "admin/base"
    end
    private :headless_layout

    def headless_mode?
      params[:_popup]
    end

  end
end
