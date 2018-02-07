require 'test_helper'

class IDashControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  # test "should have pastehuffer header" do
  #   get :index
  #   assert_select 'header','PasteHuffer'
  # end
  
  test "index returns false when no AUID is provided" do
    get :index
    response = JSON.parse(@response.body)
    assert_equal false, response["success"]
  end
  
  test "upload returns false when no AUID is provided" do
    get :upload
    response = JSON.parse(@response.body)
    assert_equal false, response["success"]
  end
  
  test "getWhiteList returns false when no AUID is provided" do
    get :getWhiteList
    response = JSON.parse(@response.body)
    assert_equal false, response["success"]
  end
  
  test "addToWhiteList returns false when no AUID is provided" do
    get :addToWhiteList
    response = JSON.parse(@response.body)
    assert_equal false, response["success"]
  end
  
  test "deleteFromWhiteList returns false when no AUID is provided" do
    get :deleteFromWhiteList
    response = JSON.parse(@response.body)
    assert_equal false, response["success"]
  end
  # test "should have course tabs" do
  #   get :index
  #   assert_select ''
  #   Courses.name
  # end
  
  # test "should be able to add a new course" do
  #   get :index
    
  # end
  
  # test "should have create assignment button" do
  #   get :index
    
  # end
end
