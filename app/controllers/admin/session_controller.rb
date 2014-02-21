class Admin::SessionController < Admin::BaseController

  skip_before_filter :reload_config_and_roles, :authenticate

  before_filter :create_an_account?, :only => [:new, :create]

  def new; end

  def create
    email, password = admin_user_params[:email], admin_user_params[:password]
    user = user_scope.authenticate(email, password)

    path = if user
      session[:typus_user_id] = user.id
      params[:return_to] || admin_dashboard_index_path
    else
      new_admin_session_path(:return_to => params[:return_to])
    end

    redirect_to path
  end

  def destroy
    deauthenticate
  end

  private

  def create_an_account?
    redirect_to new_admin_account_path if zero_users
  end

  def set_locale
    I18n.locale = Typus::I18n.default_locale
  end

  def user_scope
    klass = Typus.user_class
    klass.respond_to?(:in_domain) ? klass.in_domain(request.host) : klass
  end

end
