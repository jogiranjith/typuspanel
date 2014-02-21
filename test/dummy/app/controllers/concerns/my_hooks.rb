require 'active_support/concern'

module MyHooks

  extend ActiveSupport::Concern

  included do
    before_filter :switch_label
  end

  def switch_label
  end

end
