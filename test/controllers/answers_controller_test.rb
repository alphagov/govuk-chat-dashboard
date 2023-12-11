require "test_helper"

class AnswersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user)
    sign_in(@user)
  end

  test 'should authenticate' do
    sign_out(@user)
    get answers_url, params: {
      header: "was_answer_useful",
      value: "yes"
    }
    assert_redirected_to new_user_session_path
  end

  test "index lists answers" do
    get answers_url, params: {
      header: "experience_with_chat",
      value: "t"
    }
    assert_response :success
    assert_includes response.body, "Experience with chat : t"
  end

  test "index doesn't list answers" do
    get answers_url, params: {
      header: "was_answer_useful",
      value: "t"
    }
    assert_response :success
    assert_includes response.body, "Was answer useful : t"
  end

  test "should get show" do
    get answer_url(answers(:one))
    assert_response :success
    assert_includes response.body, "Survey responses"
  end
end
