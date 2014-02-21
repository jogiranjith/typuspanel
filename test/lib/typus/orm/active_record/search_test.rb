require "test_helper"

class ActiveRecordTest < ActiveSupport::TestCase

  test 'build_search_conditions should work for Post (title)' do
    output = Post.build_search_conditions("search", "bacon")

    expected = case db_adapter
               when "postgresql"
                 "LOWER(TEXT(posts.title)) LIKE '%bacon%'"
               else
                 "posts.title LIKE '%bacon%'"
               end

    assert_equal expected, output
  end

  test 'build_search_conditions should work for Comment (email, body)' do
    output = Comment.build_search_conditions("search", "bacon")

    expected = case db_adapter
               when "postgresql"
                 ["LOWER(TEXT(comments.body)) LIKE '%bacon%'",
                  "LOWER(TEXT(comments.email)) LIKE '%bacon%'"]
               else
                 ["comments.body LIKE '%bacon%'",
                  "comments.email LIKE '%bacon%'"]
               end

    expected.each { |e| assert_match e, output }
    assert_match /OR/, output
  end

  test 'build_search_conditions should generate conditions for id' do
    Post.stub :typus_defaults_for, %w(id) do
      expected = case db_adapter
                 when "postgresql"
                   "LOWER(TEXT(posts.id)) LIKE '%1%'"
                 else
                   "posts.id LIKE '%1%'"
                 end
      output = Post.build_search_conditions("search", "1")

      assert_equal expected, output
    end
  end

  test 'build_search_conditions should generate conditions for fields starting with equal' do
    Post.stub :typus_defaults_for, %w(=id) do
      expected = case db_adapter
                 when "postgresql"
                   "LOWER(TEXT(posts.id)) LIKE '1'"
                 else
                   "posts.id LIKE '1'"
                 end
      output = Post.build_search_conditions("search", "1")

      assert_equal expected, output
    end
  end

  test 'build_search_conditions should generate conditions for fields starting with ^' do
    Post.stub :typus_defaults_for, %w(^id) do
      expected = case db_adapter
                 when "postgresql"
                   "LOWER(TEXT(posts.id)) LIKE '1%'"
                 else
                   "posts.id LIKE '1%'"
                 end
      output = Post.build_search_conditions("search", "1")

      assert_equal expected, output
    end
  end

  test "build_boolean_conditions returns true" do
    expected = {'status'=>true}
    assert_equal expected, Page.build_boolean_conditions('status', 'true')
  end

  test "build_boolean_conditions returns false" do
    expected = {'status'=>false}
    assert_equal expected, Page.build_boolean_conditions('status', 'false')
  end

  %w(all_day all_week all_month all_year).each do |interval|
    test "build_datetime_conditions accepts #{interval}" do
      output = Article.build_datetime_conditions('created_at', interval).first
      assert_equal "articles.created_at BETWEEN ? AND ?", output
    end
  end

  test "build_datetime_condition does not accept invalid interval" do
    assert_raises RuntimeError do
      Article.build_datetime_conditions('created_at', 'tomorrow')
    end
  end

  test "build_string_conditions" do
    expected = {'test'=>'true'}
    assert_equal expected, Page.build_string_conditions('test', 'true')
  end

  # TODO: build_has_many_conditions with non-standard primary keys
  test "build_has_many_conditions" do
    expected = ["projects.id = ?", "1"]
    assert_equal expected, User.build_has_many_conditions('projects', '1')
  end

  test "build_conditions should return an array" do
    assert Post.build_conditions({:search => '1'}).is_a?(Array)
  end

  test "build_conditions should return_sql_conditions_on_search_for_typus_user" do
    expected = case db_adapter
               when "postgresql"
                 ["LOWER(TEXT(typus_users.first_name)) LIKE '%francesc%'",
                  "LOWER(TEXT(typus_users.last_name)) LIKE '%francesc%'", 
                  "LOWER(TEXT(typus_users.email)) LIKE '%francesc%'",
                  "LOWER(TEXT(typus_users.role)) LIKE '%francesc%'"]
               else
                 ["typus_users.first_name LIKE '%francesc%'",
                  "typus_users.last_name LIKE '%francesc%'",
                  "typus_users.email LIKE '%francesc%'",
                  "typus_users.role LIKE '%francesc%'"]
               end

    [{:search =>"francesc"}, {:search => "Francesc"}].each do |params|
      expected.each do |expect|
        assert_match expect, TypusUser.build_conditions(params).first
      end
      assert_no_match /AND/, TypusUser.build_conditions(params).first
    end
  end

  test 'build_conditions should return_sql_conditions_on_search_and_filter_for_typus_user' do
    expected = case db_adapter
               when "postgresql"
                 ["LOWER(TEXT(typus_users.role)) LIKE '%francesc%'",
                  "LOWER(TEXT(typus_users.last_name)) LIKE '%francesc%'",
                  "LOWER(TEXT(typus_users.email)) LIKE '%francesc%'",
                  "LOWER(TEXT(typus_users.first_name)) LIKE '%francesc%'"]
               else
                 ["typus_users.first_name LIKE '%francesc%'",
                  "typus_users.last_name LIKE '%francesc%'",
                  "typus_users.email LIKE '%francesc%'",
                  "typus_users.role LIKE '%francesc%'"]
               end

    params = { :search => "francesc", :status => "true" }

    FactoryGirl.create(:typus_user, :email => "francesc.one@example.com")
    FactoryGirl.create(:typus_user, :email => "francesc.dos@example.com", :status => false)

    resource = TypusUser
    resource.build_conditions(params).each do |condition|
      resource = resource.where(condition)
    end

    assert_equal ["francesc.one@example.com"], resource.map(&:email)
  end

  test 'build_conditions return_sql_conditions_on_filtering_typus_users_by_status true' do
    expected = { :status => true }
    assert_equal expected, TypusUser.build_conditions({:status => 'true'}).first
  end

  test 'build_conditions should return_sql_conditions_on_filtering_typus_users_by_status false' do
    expected = { :status => false }
    assert_equal expected, TypusUser.build_conditions({:status => 'false'}).first
  end

  # This applies for all_day, all_week, all_month, all_year, so there's no
  # need to repeat them.
  test 'build_conditions should return sql conditions on filtering posts published_at all_day' do
    all_day = Time.zone.now.all_day
    expected = ["posts.published_at BETWEEN ? AND ?", all_day.first.to_s(:db), all_day.last.to_s(:db)]
    assert_equal expected, Post.build_conditions({:published_at => "all_day"}).first
  end

  test 'build_conditions return_sql_conditions_on_filtering_posts_by_string' do
    expected = { :role => 'admin' }
    assert_equal expected, TypusUser.build_conditions({:role => 'admin'}).first
  end

  test "build_my_joins return the expected joins" do
    @project = FactoryGirl.create(:project)
    FactoryGirl.create_list(:project, 2)
    assert_equal [:projects], User.build_my_joins({:projects => @project.id})
  end

  test "build_my_joins works when users are filtered by projects" do
    @project = FactoryGirl.create(:project)
    FactoryGirl.create_list(:project, 2)

    params = { :projects => @project.id }

    @resource = User
    @resource.build_conditions(params).each { |c| @resource = @resource.where(c) }
    @resource.build_my_joins(params).each { |j| @resource = @resource.joins(j) }

    assert_equal [@project.user.id], @resource.map(&:id)
  end

end
