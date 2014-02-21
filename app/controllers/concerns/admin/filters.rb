# How to setup a predefined filter?
# ---------------------------------
#
# On your controllers:
#
#     def index
#       # Added predefined filter takes any argument, but in the views we
#       # expected the following:
#       #
#       #     add_predefined_filter(filter_name, action, scope)
#       #
#       ...
#       add_predefined_filter("Trash", "trash", "deleted")
#       ...
#     end
#
# On your views:
#
#     <% predefined_filters.each do |filter_name, action, scope| %>
#       ...
#     <% end %>
#

require 'active_support/concern'

module Admin
  module Filters

    extend ActiveSupport::Concern

    included do
      helper_method :predefined_filters
    end

    protected

    def add_predefined_filter(*args)
      predefined_filters
      @predefined_filters << args unless args.empty?
    end

    def prepend_predefined_filter(*args)
      predefined_filters
      @predefined_filters = @predefined_filters.unshift(args) unless args.empty?
    end

    def append_predefined_filter(*args)
      predefined_filters
      @predefined_filters = @predefined_filters.concat([args]) unless args.empty?
    end

    def predefined_filters
      @predefined_filters ||= []
    end

  end
end
