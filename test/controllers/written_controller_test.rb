require "test_helper"

class WrittenControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in(users(:user))
    get written_index_url
    assert_response :success
    assert_includes response.body, "Survey responses"
  end

  test "redirects to sign in in when unauthenticated" do
    get written_index_url
    assert_redirected_to new_user_session_path
  end
end
