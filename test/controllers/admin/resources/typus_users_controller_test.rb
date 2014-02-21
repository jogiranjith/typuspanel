require "test_helper"

=begin

  What's being tested here?

    - Stuff related to Admin users. (a.k.a. Profile Stuff)

=end

class Admin::TypusUsersControllerTest < ActionController::TestCase

  def setup_admin
    admin_sign_in
    @typus_user_editor = FactoryGirl.create(:typus_user, :email => "editor@example.com", :role => "editor")
    @request.env['HTTP_REFERER'] = '/admin/typus_users'
  end

  test "admin should be able to render new" do
    setup_admin
    get :new
    assert_response :success
  end

  test "admin should not be able to toogle his status" do
    setup_admin
    get :toggle, { :id => @typus_user.id, :field => 'status' }
    assert_response :unprocessable_entity
  end

  test "admin should be able to toggle other users status" do
    setup_admin
    get :toggle, { :id => @typus_user_editor.id, :field => 'status' }
    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Typus user successfully updated.", flash[:notice]
  end

  test "admin should not be able to destroy himself" do
    setup_admin
    delete :destroy, :id => @typus_user.id
    assert_response :unprocessable_entity
  end

  test "admin should be able to destroy other users" do
    setup_admin

    assert_difference('TypusUser.count', -1) do
      delete :destroy, :id => @typus_user_editor.id
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Typus user successfully removed.", flash[:notice]
  end

  test "admin should be able to update his profile" do
    setup_admin

    post :update, :id => @typus_user.id, :typus_user => { :first_name => "John", :last_name => "Locke", :role => 'admin', :status => '1' }, :_save => true

    assert_response :redirect
    assert_redirected_to "/admin/typus_users"
    assert_equal "Typus user successfully updated.", flash[:notice]
    assert_equal "John", @typus_user.reload.first_name
  end

  test "admin should not be able to change his role" do
    setup_admin
    post :update, :id => @typus_user.id, :typus_user => { :role => 'editor' }, :_save => true
    assert_response :unprocessable_entity
  end

  test "admin should not be able to change his status" do
    setup_admin
    post :update, :id => @typus_user.id, :typus_user => { :status => '0' }, :_save => true
    assert_response :unprocessable_entity
  end

  test "admin should be able to update other users role" do
    setup_admin

    post :update, :id => @typus_user_editor.id, :typus_user => { :role => 'admin' }, :_save => true

    assert_response :redirect
    assert_redirected_to "/admin/typus_users"
    assert_equal "Typus user successfully updated.", flash[:notice]
  end

  test "editor should not be able to create typus_users" do
    editor_sign_in
    get :new
    assert_response :unprocessable_entity
  end

  test "editor should be able to edit his profile" do
    editor_sign_in
    get :edit, :id => @typus_user.id
    assert_response :success
  end

  test "editor should be able to update his profile" do
    editor_sign_in
    post :update, :id => @typus_user.id, :typus_user => { :role => 'editor' }, :_continue => true
    assert_response :redirect
    assert_redirected_to "/admin/typus_users/edit/#{@typus_user.id}"
    assert_equal "Typus user successfully updated.", flash[:notice]
  end

  test "editor should not be able to change his role" do
    editor_sign_in
    post :update, :id => @typus_user.id, :typus_user => { :role => 'admin' }, :_continue => true
    assert_response :redirect
    assert_redirected_to "/admin/typus_users/edit/#{@typus_user.id}"
    assert_equal "editor", @typus_user.role
  end

  test "editor should not be able to destroy his profile" do
    editor_sign_in
    delete :destroy, :id => @typus_user.id
    assert_response :unprocessable_entity
  end

  test "editor should not be able to toggle his status" do
    editor_sign_in
    get :toggle, { :id => @typus_user.id, :field => 'status' }
    assert_response :unprocessable_entity
  end

  test "editor should not be able to edit other profiles" do
    editor_sign_in
    get :edit, :id => FactoryGirl.create(:typus_user).id
    assert_response :unprocessable_entity
  end

  test "editor should not be able to update other profiles" do
    editor_sign_in
    post :update, :id => FactoryGirl.create(:typus_user).id, :typus_user => { :role => 'admin' }
    assert_response :unprocessable_entity
  end

  test "editor should not be able to destroy other profiles" do
    editor_sign_in
    delete :destroy, :id => FactoryGirl.create(:typus_user).id
    assert_response :unprocessable_entity
  end

  test "editor should not be able to toggle other profiles status" do
    editor_sign_in
    get :toggle, :id => FactoryGirl.create(:typus_user).id, :field => 'status'
    assert_response :unprocessable_entity
  end

  test "designer should be able to edit his profile" do
    designer_sign_in

    get :edit, :id => @typus_user.id
    assert_response :success
  end

  test "designer should be able to update his profile" do
    designer_sign_in

    post :update, :id => @typus_user.id, :typus_user => { :role => 'designer', :email => 'designer@withafancydomain.com' }, :_save => true

    assert_response :redirect
    assert_redirected_to "/admin/typus_users"
    assert_equal "Typus user successfully updated.", flash[:notice]
    assert_equal "designer@withafancydomain.com", assigns(:item).email
  end

end
