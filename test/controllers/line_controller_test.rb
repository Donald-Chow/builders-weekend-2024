require "test_helper"

class LineControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get line_create_url
    assert_response :success
  end
end
