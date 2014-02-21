require "test_helper"

class Admin::MailerTest < ActiveSupport::TestCase

  test "reset_password_instructions" do
    host = 'example.com'
    user = FactoryGirl.build(:typus_user, :token => "qswed3-64g3fb")
    mail = Admin::Mailer.reset_password_instructions(user, host)

    refute mail.from.empty?
    assert mail.to.include?(user.email)

    expected = "[#{Typus.admin_title}] Reset password"
    assert_equal expected, mail.subject
    assert_equal "multipart/alternative", mail.mime_type

    url = "http://#{host}/admin/account/#{user.token}"
    assert_match url, mail.body.encoded
  end

  # This is a kind of hack to verify we are properly setting a value.
  test 'from is set from test.rb' do
    assert_equal 'typus@example.com', Admin::Mailer.default[:from]
  end

end
