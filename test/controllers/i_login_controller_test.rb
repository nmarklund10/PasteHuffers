require 'test_helper'

class ILoginControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should ask to create account" do
    post :testLogin, :name => "Paste Huffer", :email => "pastehuffer@tamu.edu"
    response = JSON.parse(@response.body)
    assert_equal true, response['create']
    assert_equal 'Paste Huffer', response['name']
    assert_equal 'pastehuffer@tamu.edu', response['email']
  end
  
  test "should login as admin" do
    post :testLogin, :name => "Neil Young", :email => "NeilYoung@tamu.edu"
    response = JSON.parse(@response.body)
    assert_equal 'Neil Young', response['name']
  end
  
  test "should login as normal user" do
    post :testLogin, :name => "Kraig Orcutt", :email => "kwizzle@gmail.com"
    response = JSON.parse(@response.body)
    assert_equal 'Kraig Orcutt', response['name']
  end
  
  test "should get index" do
  	get :index
  	assert_template layout: "layouts/application"
  	assert_template "i_login/login"
  end

  test "should have title" do
  	get :index
  	assert_select 'header', "PasteHuffer"
  end

  # test "should have student login button" do
  # 	get :index
  # 	assert_select 'button', "Student Login"
  # end

  # test "should have register button" do
  # 	get :index
  # 	assert_select 'button', "Register"
  # end

  # test "should have username field" do
  # 	get :index
  # 	assert_select "input:match('placeholder', ?)", "Username"
  # end

  # test "should have password field" do
  # 	get :index
  # 	assert_select "input:match('placeholder', ?)", "Password"
  # end

  test "should have login button" do
  	get :index
  	assert_select "input:match('value', ?)", "Login"
  end

  # test "should login successfully" do
  # 	get :verifyCreds, {'username' => "SomeGuy", 'password' => "1234"}
  # 	response = JSON.parse(@response.body)
  # 	assert_equal true, response['success']
  # end

  # test "should fail login with incorrect username or password" do
  # 	get :verifyCreds, {'username' => "SomeGuy", 'password' => "123"}
  # 	response = JSON.parse(@response.body)
  # 	assert_equal false, response['success'] , "should fail with correct username but wrong password"
  # 	assert_equal "Incorrect Username or Password", response['reason']
  # 	get :verifyCreds, {'username' => "SomeGuys", 'password' => "1234"}
  # 	response = JSON.parse(@response.body)
  # 	assert_equal false, response['success'], "should fail with wrong username"
  # 	assert_equal "Incorrect Username or Password", response['reason']
  # end
  # test "verifyCreds returns false when no AUID is provided" do
  #   get :verifyCreds
  #   response = JSON.parse(@response.body)
  #   assert_equal false, response["success"]
  # end



end
