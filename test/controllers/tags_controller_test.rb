require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tag = tags(:one)
    sign_in(users(:user))
  end

  test "should get index" do
    get tags_url, as: :json
    assert_response :success
  end

  test "should authenticate" do
    sign_out(users(:user))
    get tags_url, as: :json
    assert_response :unauthorized
    assert_equal '{"error":"You need to sign in or sign up before continuing."}', response.body
  end

  test "should create tag" do
    assert_difference("Tag.count") do
      post tags_url, params: { tag: { chat_id: @tag.chat_id, title: @tag.title, value: @tag.value } }, as: :json
    end

    assert_response :created
  end

  test "should show tag" do
    get tag_url(@tag), as: :json
    assert_response :success
  end

  test "should update tag" do
    patch tag_url(@tag), params: { tag: { chat_id: @tag.chat_id, title: @tag.title, value: @tag.value } }, as: :json
    assert_response :success
  end

  test "should destroy tag" do
    assert_difference("Tag.count", -1) do
      delete tag_url(@tag), as: :json
    end

    assert_response :no_content
  end
end
