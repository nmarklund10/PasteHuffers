require 'test_helper'

class SLoginControllerTest < ActionController::TestCase
  test "verifyCreds returns false when no AUID is provided" do
    get :verifyCreds
    response = JSON.parse(@response.body)
    assert_equal false, response["success"]
  end
  test "index should render new template" do
    get :index
    assert_template :s_login2
  end
  test "getAssignmentID should render new template" do
    get :getAssignmentID
    assert_template :getAssignmentID
  end
end
