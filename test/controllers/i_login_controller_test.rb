require 'test_helper'

class ILoginControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should get index" do
  	get :index
  	assert_template layout: "layouts/application"
  	assert_template "i_login/login"
  end

  test "should have title" do
  	get :index
  	assert_select 'header', "PasteHuffer"
  end

  test "should have student login button" do
  	get :index
  	assert_select 'button', "Student Login"
  end

  test "should have register button" do
  	get :index
  	assert_select 'button', "Register New Account"
  end

  test "should have username field" do
  	get :index
  	assert_select "input:match('placeholder', ?)", "Username"
  end

  test "should have password field" do
  	get :index
  	assert_select "input:match('placeholder', ?)", "Password"
  end

  test "should have login button" do
  	get :index
  	assert_select "input:match('value', ?)", "Login"
  end





end
