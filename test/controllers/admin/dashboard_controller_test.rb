require "test_helper"

class Admin::DashboardControllerTest < ActionController::TestCase

  # test "http_basic authentication should return a 401 message when no credentials sent" do
  #   Admin::DashboardController.send :include, Typus::Authentication::HttpBasic
  #   get :index
  #   assert_response :unauthorized
  # end

  # test " http_basic authentication should authenticate user with valid password" do
  #   Admin::DashboardController.send :include, Typus::Authentication::HttpBasic
  #   @request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64::encode64("admin:columbia")
  #   get :index
  #   assert_response :success
  # end

  # test "http_basic authentication should not authenticate user with invalid password" do
  #   Admin::DashboardController.send :include, Typus::Authentication::HttpBasic
  #   @request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64::encode64("admin:admin")
  #   get :index
  #   assert_response :unauthorized
  # end

  # test "none authentication should render dashboard" do
  #   Admin::DashboardController.send :include, Typus::Authentication::None
  #   get :index
  #   assert_response :success
  # end

  test 'not logged should redirect to sign in when not signed in' do
    reset_session
    get :index
    assert_response :redirect
    assert_redirected_to new_admin_session_path
  end

  test 'should verify a removed role cannot sign_in' do
    typus_user = FactoryGirl.create(:typus_user, :role => "removed")
    @request.session[:typus_user_id] = typus_user.id

    get :index

    assert_response :redirect
    assert_redirected_to new_admin_session_path
    assert_nil @request.session[:typus_user_id]
  end

  test 'admin should render dashboard' do
    admin_sign_in
    get :index

    assert_response :success
    assert_template "index"
    assert_template "layouts/admin/base"

    # verify title
    assert_select "title", "Typus &mdash; Dashboard"

    # verify link to session sign out
    link = %(href="/admin/session")
    assert_match link, response.body

    # verify link to edit user
    link = %(href="/admin/typus_users/edit/#{@request.session[:typus_user_id]})
    assert_match link, response.body

    # verify we can set our own partials
    partials = %w( _sidebar.html.erb )
    partials.each { |p| assert_match p, response.body }
  end

  test 'security should block users_on_the_fly' do
    admin_sign_in

    @typus_user.status = false
    @typus_user.save

    get :index

    assert_response :redirect
    assert_redirected_to new_admin_session_path
    assert_nil @request.session[:typus_user_id]
  end

  test 'security should sign out user when role does not longer exist' do
    admin_sign_in

    @typus_user.role = 'unexisting'
    @typus_user.save

    get :index

    assert_response :redirect
    assert_redirected_to new_admin_session_path
    assert_nil @request.session[:typus_user_id]
  end

  test "designer should not see links to unallowed resources" do
    designer_sign_in
    get :index
    assert_no_match /\/admin\/posts\/new/, response.body
    assert_no_match /\/admin\/typus_users\/new/, response.body
  end

end
