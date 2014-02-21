require "test_helper"

class TypusUserRolesTest < ActiveSupport::TestCase

  test "configuration roles" do
    assert_equal %w(admin designer editor), Typus::Configuration.roles.map(&:first).sort
  end

  test 'admin role' do
    typus_user = FactoryGirl.create(:typus_user)

    expected = %w(Article::Entry Asset Bird Case Category Comment
                  DeviseUser Dog Entry EntryBulk EntryDefault EntryTrash Git
                  ImageHolder Invoice Order Page Post Project ProjectCollaborator
                  ReadOnlyEntry Status Task TypusUser User View WatchDog)
    assert_equal expected, typus_user.resources.map(&:first).sort

    # FIXME: Order is not included in the list of resources ...
    # assert !@typus_user.resources.map(&:first).include?('Order')

    # have access to all actions on models
    models = %w(Asset Category Comment Page Post TypusUser View)
    %w(create read update destroy).each { |a| models.each { |m| assert typus_user.can?(a, m) } }

    # verify we can perform action on resource
    assert typus_user.can?('index', 'Status', { :special => true })

    # verify we cannot perform action on resource
    assert typus_user.cannot?('show', 'Status', { :special => true })

    # FIXME: verify we cannot perform actions on resources which don't have that action defined
    # assert @typus_user.cannot?('index', 'Order')
  end

  test 'editor role' do
    typus_user = FactoryGirl.create(:typus_user, :role => "editor")

    expected = %w(Comment Git Post View)
    assert_equal expected, typus_user.resources.map(&:first).sort

    %w(create read update).each { |a| assert typus_user.can?(a, 'Post') }
    %w(delete).each { |a| assert typus_user.cannot?(a, 'Post') }

    %w(read update delete).each { |a| assert typus_user.can?(a, 'Comment') }
    %w(create).each { |a| assert typus_user.cannot?(a, 'Comment') }

    %w().each { |a| assert typus_user.can?(a, 'TypusUser') }
    %w().each { |a| assert typus_user.cannot?(a, 'TypusUser') }
  end

  test 'designer role' do
    typus_user = FactoryGirl.create(:typus_user, :role => 'designer')

    expected = %w(Comment Post)
    assert_equal expected, typus_user.resources.map(&:first).sort

    %w(read).each { |a| assert typus_user.can?(a, 'Comment') }
    %w(create update delete).each { |a| assert typus_user.cannot?(a, 'Comment') }

    %w(read update).each { |a| assert typus_user.can?(a, 'Post') }
    %w(create delete).each { |a| assert typus_user.cannot?(a, 'Post') }
  end

end
