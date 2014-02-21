require "test_helper"

=begin

  Here we test:

  - Typus::Orm::ActiveRecord::AdminUserV1

=end

class TypusUserTest < ActiveSupport::TestCase

  test "validate email" do
    assert FactoryGirl.build(:typus_user, :email => "dong").invalid?
    assert FactoryGirl.build(:typus_user, :email => "john@example.com").valid?
    assert FactoryGirl.build(:typus_user, :email => nil).invalid?
  end

  test "validate :role" do
    assert FactoryGirl.build(:typus_user, :role => nil).invalid?
  end

  test "validate :password" do
    assert FactoryGirl.build(:typus_user, :password => "XXXXXXXX").valid?
    # TODO: Take back these tests.
    # assert FactoryGirl.build(:typus_user, :password => "0"*5).invalid?
    # assert FactoryGirl.build(:typus_user, :password => "0"*6).valid?
    # assert FactoryGirl.build(:typus_user, :password => "0"*40).valid?
    # assert FactoryGirl.build(:typus_user, :password => "0"*41).invalid?
    # assert FactoryGirl.build(:typus_user, :password => "").invalid?
  end

  test "generate" do
    refute TypusUser.generate

    options = { :email => FactoryGirl.build(:typus_user).email }
    typus_user = TypusUser.generate(options)
    assert_equal options[:email], typus_user.email

    typus_user_factory = FactoryGirl.build(:typus_user)
    options = { :email => typus_user_factory.email, :password => typus_user_factory.password }
    typus_user = TypusUser.generate(options)
    assert_equal options[:email], typus_user.email

    typus_user_factory = FactoryGirl.build(:typus_user)
    options = { :email => typus_user_factory.email, :role => typus_user_factory.role }
    typus_user = TypusUser.generate(options)
    assert_equal options[:email], typus_user.email
    assert_equal options[:role], typus_user.role
  end

  test "should verify authenticated? returns true or false" do
    typus_user = FactoryGirl.create(:typus_user)
    assert typus_user.authenticated?('12345678')
    refute typus_user.authenticated?('87654321')
  end

  test "should verify preferences are nil by default" do
    typus_user = FactoryGirl.create(:typus_user)
    assert typus_user.preferences.nil?
  end

  test "should return default_locale when no preferences are set" do
    typus_user = FactoryGirl.create(:typus_user)
    assert typus_user.locale.eql?(:en)
  end

  test "should be able to set a locale" do
    typus_user = FactoryGirl.create(:typus_user)
    typus_user.locale = :jp

    expected = {:locale => :jp}
    assert_equal expected, typus_user.preferences
    assert typus_user.locale.eql?(:jp)
  end

  test "should be able to set preferences" do
    typus_user = FactoryGirl.create(:typus_user)
    typus_user.preferences = {:chunky => "bacon"}
    assert typus_user.preferences.present?
  end

  test "should set locale preference without overriding previously set preferences" do
    typus_user = FactoryGirl.create(:typus_user)

    typus_user.preferences = {:chunky => "bacon"}
    typus_user.locale = :jp

    expected = {:locale => :jp, :chunky => "bacon"}
    assert_equal expected, typus_user.preferences
  end

  test "to_label" do
    user = FactoryGirl.build(:typus_user)
    assert_equal user.email, user.to_label
  end

  test "admin gets a list of all applications" do
    typus_user = FactoryGirl.build(:typus_user)
    assert_equal Typus.applications, typus_user.applications
  end

  test "admin gets a list of application resources for Admin application" do
    typus_user = FactoryGirl.build(:typus_user)
    expected = %w(TypusUser DeviseUser).sort
    assert_equal expected, typus_user.application("Admin").sort
  end

  test "editor get a list of all applications" do
    typus_user = FactoryGirl.build(:typus_user, :role => "editor")
    expected = ["Admin", "CRUD Extended"]
    expected.each { |e| assert Typus.applications.include?(e) }
  end

  test "editor gets a list of application resources" do
    typus_user = FactoryGirl.build(:typus_user, :role => "editor")
    assert_equal %w(Comment Post), typus_user.application("CRUD Extended")
    assert typus_user.application("Admin").empty?
  end

  test "user owns a resource" do
    typus_user = FactoryGirl.build(:typus_user)
    resource = FactoryGirl.build(:post, :typus_user => typus_user)
    assert typus_user.owns?(resource)
  end

  test "user does not own a resource" do
    typus_user = FactoryGirl.create(:typus_user)
    resource = FactoryGirl.create(:post, :typus_user => FactoryGirl.create(:typus_user))
    refute typus_user.owns?(resource)
  end

  test "token changes everytime we save the user" do
    admin_user = FactoryGirl.create(:typus_user)
    first_token = admin_user.token
    admin_user.save
    second_token = admin_user.token
    refute first_token.eql?(second_token)
  end

end
