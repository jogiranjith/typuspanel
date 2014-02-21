require "test_helper"

=begin

  What's being tested here?

    - has_and_belongs_to

=end

class Admin::EntriesControllerTest < ActionController::TestCase

  setup do
    admin_sign_in
  end

  test 'adding multiple categories to an entry' do
    Entry.delete_all

    category_1 = FactoryGirl.create(:category)
    category_2 = FactoryGirl.create(:category)

    assert_difference('Entry.count') do
      entry_data = {
        :title => 'Title' ,
        :content => 'Content',
        :category_ids => ["", "#{category_1.id}", "#{category_2.id}" ]
      }

      post :create, :entry => entry_data
    end

    assert_equal [category_1, category_2], Entry.first.categories
  end

end
