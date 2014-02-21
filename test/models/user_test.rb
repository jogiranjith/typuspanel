require "test_helper"

=begin

  Here we test:

  - Typus::Orm::ActiveRecord::User::InstanceMethods

=end

class UserTest < ActiveSupport::TestCase

  test "to_label" do
    user = FactoryGirl.build(:typus_user)
    assert_equal user.email, user.to_label
  end

  test "can?" do
    user = FactoryGirl.build(:typus_user, :role => 'admin')
    assert user.can?('delete', TypusUser)
    refute user.cannot?('delete', TypusUser)
    assert user.can?('delete', 'TypusUser')
    refute user.cannot?('delete', 'TypusUser')
  end

  test "is_root?" do
    user = FactoryGirl.build(:typus_user, :role => 'admin')
    assert user.is_root?
    refute user.is_not_root?
  end

  test "active?" do
    assert FactoryGirl.build(:typus_user, :role => 'admin', :status => true).active?
    refute FactoryGirl.build(:typus_user, :role => 'admin', :status => false).active?
    refute FactoryGirl.build(:typus_user, :role => 'unexisting', :status => true).active?
    refute FactoryGirl.build(:typus_user, :role => 'unexisting', :status => false).active?
  end

end
