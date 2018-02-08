require 'test_helper'

class CeControllerTest < ActionController::TestCase
  test "index returns false when no AUID is provided" do
    get :index
    response = JSON.parse(@response.body)
    assert_equal false, response["success"]
  end
  test "testCode returns false when no AUID is provided" do
    get :testCode
    response = JSON.parse(@response.body)
    assert_equal false, response["success"]
  end
end
