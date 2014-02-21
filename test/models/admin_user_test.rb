require "test_helper"

=begin

  Here we test:

  - Typus::Orm::ActiveRecord::AdminUser
  - Typus::Orm::ActiveRecord::User::ClassMethods

=end

class AdminUserTest < ActiveSupport::TestCase

  test "token changes everytime we save the user" do
    admin_user = FactoryGirl.create(:typus_user)
    first_token = admin_user.token
    admin_user.save
    second_token = admin_user.token
    refute first_token.eql?(second_token)
  end

  test "mapping locales" do
    admin_user = FactoryGirl.build(:typus_user, :locale => "en")
    assert_equal "English", admin_user.mapping(:locale)
  end

  test "locales" do
    assert_equal Typus::I18n.available_locales, AdminUser.locales
  end

  test "roles" do
    assert_equal Typus::Configuration.roles.keys.sort, AdminUser.roles
  end

  test "validate :password" do
    admin_user = FactoryGirl.build(:typus_user, :password => "00000")
    assert admin_user.invalid?
    assert_equal "is too short (minimum is 6 characters)", admin_user.errors[:password].first

    assert FactoryGirl.build(:typus_user, :password => "000000").valid?
  end

end
