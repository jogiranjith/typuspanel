require "test_helper"

=begin

  What's being tested here?

    - Sessions

=end

class Admin::SessionControllerTest < ActionController::TestCase

  test "verify_remote_ip" do
    Typus.ip_whitelist = %w(10.0.0.5)
    get :new
    assert_equal "IP not in our whitelist.", @response.body

    request.stub :local?, true do
      Typus.ip_whitelist = %w(10.0.0.5)
      get :new
      assert_response :redirect
      assert_redirected_to new_admin_account_path

      Typus.ip_whitelist = []
      get :new
      assert_response :redirect
      assert_redirected_to new_admin_account_path
    end
  end

  test "get new redirects to new_admin_account_path when no admin users" do
    get :new
    assert_response :redirect
    assert_redirected_to new_admin_account_path
  end

  test "get new always sets locale to Typus::I18n.default_locale" do
    I18n.locale = :jp
    get :new
    assert_equal :en, I18n.locale
  end

  test 'new is rendered when there are users' do
    FactoryGirl.create(:typus_user)
    Typus.mailer_sender = nil

    get :new
    assert_response :success

    # render new and verify title and header
    assert_select "title", "Typus &mdash; Sign in"
    assert_select "h1", "Typus"

    # render session layout
    assert_template "new"
    assert_template "layouts/admin/session"

    # verify_typus_sign_in_layout_does_not_include_recover_password_link
    assert !response.body.include?("Recover password")

    Typus.mailer_sender = 'john@example.com'
  end

  test "new includes recover_password_link when mailer_sender is set" do
    FactoryGirl.create(:typus_user)

    Typus.mailer_sender = 'john@example.com'

    get :new
    assert response.body.include?("Recover password")

    Typus.mailer_sender = nil
  end

  test 'create should not create session for invalid users' do
    FactoryGirl.create(:typus_user)

    post :create, { :typus_user => { :email => "john@example.com", :password => "XXXXXXXX" } }
    assert_response :redirect
    assert_redirected_to new_admin_session_path
  end

  test 'create should not create session for a disabled user' do
    typus_user = FactoryGirl.create(:typus_user, :status => false)

    post :create, { :typus_user => { :email => typus_user.email, :password => '12345678' } }

    assert_nil request.session[:typus_user_id]
    assert_response :redirect
    assert_redirected_to new_admin_session_path
  end

  test 'create should create session for an enabled user' do
    typus_user = FactoryGirl.create(:typus_user, :status => true)

    post :create, { :typus_user => { :email => typus_user.email, :password => "12345678" } }
    assert_equal typus_user.id, request.session[:typus_user_id]
    assert_response :redirect
    assert_redirected_to admin_dashboard_index_path
  end

  test 'destroy' do
    admin_sign_in
    assert request.session[:typus_user_id]
    delete :destroy

    assert_nil request.session[:typus_user_id]
    assert_response :redirect
    assert_redirected_to new_admin_session_path
    assert flash.empty?
  end

end
