require "test_helper"

=begin

  Here we test:

  - Typus::Orm::ActiveRecord::User::InstanceMethods

=end

class DeviseUserTest < ActiveSupport::TestCase

  test "to_label" do
    user = FactoryGirl.build(:devise_user)
    assert_equal user.email, user.to_label
  end

  test "can?" do
    user = FactoryGirl.build(:devise_user)
    assert user.can?('delete', TypusUser)
    refute user.cannot?('delete', TypusUser)
    assert user.can?('delete', 'TypusUser')
    refute user.cannot?('delete', 'TypusUser')
  end

  test "is_root?" do
    user = FactoryGirl.build(:devise_user)
    assert user.is_root?
    refute user.is_not_root?
  end

  test "role" do
    assert_equal 'admin', FactoryGirl.build(:devise_user).role
  end

  test "locale" do
    assert_equal :en, FactoryGirl.build(:devise_user).locale
  end

end
