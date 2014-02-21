require "support/active_record" if defined?(ActiveRecord)
require "support/hash"
require "support/object"
require "support/string"

require "typus/engine"
require "typus/regex"
require "typus/version"

require "typus/orm/base/class_methods"
require "typus/orm/base/search"
require "typus/orm/active_record"

autoload :FakeUser, "support/fake_user"

module Typus

  autoload :Configuration, "typus/configuration"
  autoload :I18n, "typus/i18n"
  autoload :Resources, "typus/resources"

  module Authentication
    autoload :Base, "typus/authentication/base"
    autoload :None, "typus/authentication/none"
    autoload :NoneWithRole, "typus/authentication/none_with_role"
    autoload :HttpBasic, "typus/authentication/http_basic"
    autoload :Session, "typus/authentication/session"

    autoload :Devise, "typus/authentication/devise"
  end

  mattr_accessor :admin_title
  @@admin_title = "Typus"

  mattr_accessor :admin_title_link
  @@admin_title_link = nil

  mattr_accessor :admin_sub_title
  @@admin_sub_title = <<-CODE
<a href="http://core.typuscmf.com/">core.typuscmf.com</a>
  CODE

  # Set authentication (none, http_basic, session)
  mattr_accessor :authentication
  @@authentication = :none

  mattr_accessor :config_folder
  @@config_folder = "config/typus"

  mattr_accessor :username
  @@username = "admin"

  mattr_accessor :subdomain
  @@subdomain = nil

  # Define a default password for http authentication.
  mattr_accessor :password
  @@password = "columbia"

  # Configure the e-mail address which will be shown in Admin::Mailer.
  # If not set `forgot_password` feature is disabled.
  mattr_accessor :mailer_sender
  @@mailer_sender = nil

  ##
  # Define `paperclip` attachment styles.
  #

  mattr_accessor :file_preview
  @@file_preview = :medium

  mattr_accessor :file_thumbnail
  @@file_thumbnail = :thumb

  ##
  # Define `dragonfly` attachment styles.
  #

  mattr_accessor :image_preview_size
  @@image_preview_size = '530x'

  mattr_accessor :image_thumb_size
  @@image_thumb_size = 'x100'

  mattr_accessor :image_table_thumb_size
  @@image_table_thumb_size = '25x25#'

  # Define the default relationship table.
  mattr_accessor :relationship
  @@relationship = "typus_users"

  mattr_accessor :master_role
  @@master_role = "admin"

  mattr_accessor :user_class_name
  @@user_class_name = "AdminUser"

  mattr_accessor :user_foreign_key
  @@user_foreign_key = "admin_user_id"

  mattr_accessor :quick_sidebar
  @@quick_sidebar = false

  mattr_accessor :ip_whitelist
  @@ip_whitelist = []

  mattr_accessor :link_to_view_site
  @@link_to_view_site = false

  mattr_accessor :link_to_help
  @@link_to_help = false

  class << self

    # Default way to setup typus. Run `rails generate typus` to create a
    # fresh initializer with all configuration values.
    def setup
      yield self
      reload!
    end

    def applications
      hash = {}

      Typus::Configuration.config.map { |i| i.last["application"] }.compact.uniq.each do |app|
        settings = app.extract_settings
        hash[settings.first] = settings.size > 1 ? settings.last : 1000
      end

      hash.sort { |a1, a2| a1[1].to_i <=> a2[1].to_i }.map(&:first)
    end

    # Lists modules of an application.
    def application(name)
      array = []

      Typus::Configuration.config.each do |i|
        settings = i.last["application"]
        array << i.first if settings && settings.extract_settings.first.eql?(name)
      end

      array.compact.uniq
    end

    # Lists models from the configuration file.
    def models
      Typus::Configuration.config.map(&:first).sort
    end

    # Lists resources, which are tableless models. This is done by looking at
    # the roles, which handle the permissions for this kind of data.
    def resources
      if roles = Typus::Configuration.roles
        roles.keys.map do |key|
          Typus::Configuration.roles[key].keys
        end.flatten.sort.uniq.delete_if { |x| models.include?(x) }
      else
        []
      end
    end

    # Lists models under <tt>app/models</tt>.
    def detect_application_models
      model_dir = Rails.root.join("app/models")
      Dir.chdir(model_dir.to_s) { Dir["**/*.rb"].reject {|f| f["concerns/"] } }
    end

    def application_models
      detect_application_models.map do |model|
        class_name = model.sub(/\.rb$/,"").camelize
        klass = class_name.split("::").inject(Object) { |klass,part| klass.const_get(part) }
        class_name if is_active_record?(klass)
      end.compact
    end

    def is_active_record?(klass)
      (defined?(ActiveRecord) && klass < ActiveRecord::Base && !klass.abstract_class?)
    end
    private :is_active_record?

    def user_class
      user_class_name.constantize
    end

    def user_class_as_symbol
      user_class_name.underscore.to_sym
    end

    def root
      Rails.root.join(config_folder)
    end

    def model_configuration_files
      app = Typus.root.join("**", "*.yml")
      lib = Rails.root.join("lib", "*", "config", "typus", "**", "*.yml")
      Dir[app.to_s, lib.to_s].reject { |f| f.match(/_roles.yml/) }.sort
    end

    def role_configuration_files
      app = Typus.root.join("**", "*_roles.yml")
      lib = Rails.root.join("lib", "*", "config", "typus", "**", "*_roles.yml")
      Dir[app.to_s, lib.to_s].sort
    end

    def reload!
      Typus::Configuration.roles!
      Typus::Configuration.models!
    end

  end

end
