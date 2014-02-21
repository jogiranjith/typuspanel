require "test_helper"

=begin

  What's being tested here?

    - Belongs To

=end

class Admin::ProjectsControllerTest < ActionController::TestCase

  setup do
    admin_sign_in
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'get new reads params[:resource] and allows the usage of _id' do
    get :new, { :resource => { :user_id => 1 } }
    assert_response :success
    assert_template 'new'
    assert_equal 1, assigns(:item).user_id
  end

  test 'get new reads params[:resource]' do
    get :new, { :resource => { :user_id => 1, :name => 'Chunky Bacon'} }
    assert_response :success
    assert_template 'new'
    assert_equal 'Chunky Bacon', assigns(:item).name
  end

  # Project has a dropdown of users and we want to make sure we are
  # creating the association properly.
  test 'should create project' do
    user = FactoryGirl.create(:user)

    assert_difference('Project.count') do
      post :create, :project => { :user_id => user.id, :name => 'Chunky Bacon' }
    end

    assert_redirected_to '/admin/projects'
  end

  test 'should update project' do
    project = FactoryGirl.create(:project)
    user = FactoryGirl.create(:user)

    patch :update, :id => project, :project => { :user_id => user.id }
    assert_redirected_to '/admin/projects'
    assert_equal user, project.reload.user
  end

end
