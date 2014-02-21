require "test_helper"

class Admin::BaseControllerTest < ActionController::TestCase

  test 'white_label' do
    base = Admin::BaseController.new
    assert base.respond_to?(:white_label)
  end

end
