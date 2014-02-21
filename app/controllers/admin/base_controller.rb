class Admin::BaseController < ActionController::Base

  include Admin::Hooks
  include Typus::Authentication::const_get(Typus.authentication.to_s.classify)

  before_filter :verify_remote_ip, :reload_config_and_roles, :authenticate, :set_locale

  helper_method :admin_user, :current_role

  protected

  def verify_remote_ip
    if !request.local? && Typus.ip_whitelist.any?
      unless Typus.ip_whitelist.include?(request.ip)
        render :text => "IP not in our whitelist."
      end
    end
  end

  def reload_config_and_roles
    Typus.reload! if Rails.env.development?
  end

  def set_locale
    I18n.locale = if admin_user && admin_user.respond_to?(:locale)
      admin_user.locale
    else
      Typus::I18n.default_locale
    end
  end

  def zero_users
    Typus.user_class.count.zero?
  end

  def not_allowed(reason = 'Not allowed!')
    render :text => reason, :status => :unprocessable_entity
  end

  def admin_user_params
    params[Typus.user_class_as_symbol]
  end

end
