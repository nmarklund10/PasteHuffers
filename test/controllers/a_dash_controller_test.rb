require 'test_helper'

class ADashControllerTest < ActionController::TestCase 
  test "no IUID returns false" do
    get :index, id: 1
    response = JSON.parse(@response.body)
    assert_equal false, response['success']
  end
end
