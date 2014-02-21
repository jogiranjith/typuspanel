require "test_helper"

class FakeUserTest < ActiveSupport::TestCase

  setup do
    @fake_user = FakeUser.new
  end

  test "should have the id set to 0" do
    assert @fake_user.id.eql?(0)
  end

  test "should be able to do anything" do
    assert @fake_user.can?("sing")
    assert !@fake_user.cannot?("sing")
  end

  test "should have a locale" do
    assert_equal ::I18n.locale, @fake_user.locale
  end

  test "should have status set to true" do
    assert @fake_user.status
  end

  test "should be considered as root" do
    assert @fake_user.is_root?
  end

  test "should not be considered as no_root" do
    assert !@fake_user.is_not_root?
  end

  test "should have access to all applications" do
    assert_equal Typus.applications, @fake_user.applications
  end

  test "FakeUser#application" do
    assert_equal Typus.application("CRUD"), @fake_user.application("CRUD")
    expected = %w(Animal Bird Dog ImageHolder).sort
    assert_equal expected, @fake_user.application("Polymorphic").sort
  end

  test "should be master_role" do
    assert_equal Typus.master_role, @fake_user.role
  end

  test "should not respond to resources" do
    assert !@fake_user.respond_to?(:resources)
  end

  test "should always be the owner of a resource" do
    assert @fake_user.owns?('a')
  end

end
