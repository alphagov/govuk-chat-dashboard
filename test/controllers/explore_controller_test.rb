require "test_helper"

class ExploreControllerTest < ActionDispatch::IntegrationTest
  test "get index contains a script block" do
    sign_in(users(:user))
    get explore_index_url
    assert_response :success
    assert_includes response.body, "script"
  end

  test "get index redirects when unauthenticated" do
    get explore_index_url
    assert_redirected_to new_user_session_path
  end
end
