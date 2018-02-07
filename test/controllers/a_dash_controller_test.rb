require 'test_helper'

class ADashControllerTest < ActionController::TestCase
  def sign_in_as_admin
    old_controller = @controller
    @controller = ILoginController.new
    post :testLogin, :name => "Neil Young", :email => "NeilYoung@tamu.edu"
    @controller = old_controller
  end
  def sign_in_as_normal_user
    old_controller = @controller
    @controller = ILoginController.new
    post :testLogin, :name => "Kraig Orcutt", :email => "kwizzle@gmail.com"
    @controller = old_controller
  end
  
  # test "load admin assignment" do
  #   sign_in_as_admin
  #   get :index, id: 3, :IUID => 3
  # 	response = JSON.parse(@response.body)
  # 	puts response
  # 	assert_equal true, response["success"]
  # end
    
  test "no IUID returns false" do
    get :index, id: 1
    response = JSON.parse(@response.body)
    assert_equal false, response['success']
  end
end
