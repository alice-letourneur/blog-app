require 'test_helper'

class CreateArticlesTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username: "Alice", email: "alice@alice.alice", password: "password", admin: false)
  end

  test "get new article form and create new article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post articles_path, params:{article: {title: "My article", description: "This is my description"}}
      follow_redirect!
    end
    assert_template 'articles/show'
    assert_match "My article", response.body
    assert_match "This is my description", response.body
  end

  test "invalid article creation due to missing info or incorrect format results in failure" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, params:{article: {title: "My", description: "This"}}
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
    assert_match "Title is too short", response.body
    assert_match "Description is too short", response.body
  end

end
