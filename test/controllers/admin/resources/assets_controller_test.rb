require "test_helper"

=begin

  What's being tested here?

    - Assets

=end

class Admin::AssetsControllerTest < ActionController::TestCase

  setup do
    admin_sign_in
    @request.env['HTTP_REFERER'] = '/admin/categories'
  end

  test 'should verify update can remove a single attribute' do
    asset = FactoryGirl.create(:asset)

    get :update, :id => asset.id, :_nullify => 'dragonfly', :_continue => true

    assert_response :redirect
    assert_redirected_to "/admin/assets/edit/#{asset.id}"
    assert_equal 'Asset successfully updated.', flash[:notice]

    refute assigns(:item).dragonfly
  end

end
