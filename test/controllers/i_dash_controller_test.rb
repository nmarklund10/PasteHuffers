require 'test_helper'

class IDashControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should have pastehuffer header" do
    get :index
    assert_select 'header','PasteHuffer'
  end
  
<<<<<<< HEAD
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
=======
  # test "should display course tabs" do
  #   get :index
  #   assert_select ''
  # end
  
  test "should be able to add a new course" do
    get :index
    
  end
  
  test "should have create assignment button" do
    get :index
    
  end
>>>>>>> 2c04bef6ec4ae8f6dca7fae8f6cb4e55e947f156
end
