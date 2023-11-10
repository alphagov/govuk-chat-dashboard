require "test_helper"

class WrittenControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get written_index_url
    assert_response :success
  end
end
