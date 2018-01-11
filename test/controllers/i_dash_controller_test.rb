require 'test_helper'

class IDashControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should have pastehuffer header" do
    get :index
    assert_select 'header','PasteHuffer'
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
