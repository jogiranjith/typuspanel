require 'active_support/concern'
require 'bcrypt'
require 'typus/orm/active_record/instance_methods'

module Typus
  module Orm
    module ActiveRecord
      module AdminUser

        extend ActiveSupport::Concern
        include Typus::Orm::ActiveRecord::InstanceMethods

        included do
          attr_reader   :password
          attr_accessor :password_confirmation

          # attr_protected :role, :status

          validates :email, :presence => true, :uniqueness => true, :format => { :with => Typus::Regex::Email }
          validates :password, :confirmation => true
          validates :password_digest, :presence => true
          validate :password_must_be_strong
          validates :role, :presence => true

          serialize :preferences

          before_save :set_token
        end

        module ClassMethods

          def authenticate(email, password)
            user = find_by_email_and_status(email, true)
            user && user.authenticated?(password) ? user : nil
          end

          def generate(*args)
            options = args.extract_options!
            options[:password] ||= Typus.password
            options[:role] ||= Typus.master_role
            options[:status] = true
            user = new(options)
            user.save ? user : false
          end

          def roles
            Typus::Configuration.roles.keys.sort
          end

          def locales
            Typus::I18n.available_locales
          end

        end

        def locale
          (preferences && preferences[:locale]) ? preferences[:locale] : ::I18n.default_locale
        end

        def locale=(locale)
          self.preferences ||= {}
          self.preferences[:locale] = locale
        end

        def authenticated?(unencrypted_password)
          equal = BCrypt::Password.new(password_digest) == unencrypted_password
          equal ? self : false
        end

        def password=(unencrypted_password)
          @password = unencrypted_password
          self.password_digest = BCrypt::Password.create(unencrypted_password)
        end

        def password_must_be_strong(count = 6)
          if password.present? && password.size < count
            errors.add(:password, :too_short, :count => count)
          end
        end

      end
    end
  end
end
