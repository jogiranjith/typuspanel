require 'active_support/concern'

module Typus
  module Controller
    module Hooks

      extend ActiveSupport::Concern

      included do
        before_filter :switch_label
      end

      def switch_label
        logger.info "%" * 72
        logger.info "%" * 72
        logger.info "%" * 72
        logger.info "%" * 72
        logger.info "%" * 72
      end

    end
  end
end
