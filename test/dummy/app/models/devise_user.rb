require 'typus/orm/active_record/instance_methods'

class DeviseUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :email, :password, :password_confirmation, :remember_me, :as => :admin

  include Typus::Orm::ActiveRecord::InstanceMethods

  # If DeviseUser#locale is not found, we will use the default one.
  def locale
    ::I18n.locale
  end

  def role
    Typus.master_role
  end

end
