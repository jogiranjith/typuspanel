class Admin::AccountController < Admin::BaseController

  layout 'admin/session'

  skip_before_filter :reload_config_and_roles, :authenticate, :set_locale

  before_filter :sign_in?, :except => [:forgot_password, :send_password, :show]
  before_filter :new?, :only => [:forgot_password, :send_password]

  def new
    flash[:notice] = Typus::I18n.t("Enter your email below to create the first user.")
  end

  def create
    user = Typus.user_class.generate(:email => admin_user_params[:email])
    redirect_to user ? { :action => "show", :id => user.token } : { :action => :new }
  end

  def forgot_password; end

  def send_password
    if user = Typus.user_class.find_by_email(admin_user_params[:email])
      Admin::Mailer.reset_password_instructions(user, request.host_with_port).deliver
      redirect_to new_admin_session_path, :notice => Typus::I18n.t("Password recovery link sent to your email.")
    else
      render :action => :forgot_password
    end
  end

  def show
    flash[:notice] = Typus::I18n.t("Please set a new password.")
    typus_user = Typus.user_class.find_by_token!(params[:id])
    session[:typus_user_id] = typus_user.id
    redirect_to params[:return_to] || { :controller => "/admin/#{Typus.user_class.to_resource}", :action => "edit", :id => typus_user.id }
  end

  private

  def sign_in?
    redirect_to new_admin_session_path unless zero_users
  end

  def new?
    redirect_to new_admin_account_path if zero_users
  end

end
