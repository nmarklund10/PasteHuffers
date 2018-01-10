require 'test_helper'

class InstructorsControllerTest < ActionController::TestCase
  test "should use the correct template" do
    get :createInstructorForm
  	assert_template layout: "layouts/application"
  	assert_template "instructors/createInstructorForm"
  end
  test "should have field: name" do
    get :createInstructorForm
  	assert_select "input:match('name', ?)", "name"
  	assert_select "label", "Name:"
  end
  test "should have field: email" do
    get :createInstructorForm
  	assert_select "input:match('name', ?)", "email"
  	assert_select "label", "Email:"
  end
  test "should have field: password" do
    get :createInstructorForm
  	assert_select "input:match('name', ?)", "password"
  	assert_select "label", "Password:"
  end
  test "should have field: password_validate" do
    get :createInstructorForm
  	assert_select "input:match('name', ?)", "password_validate"
  	assert_select "label", "Confirm Password:"
  end
  test "should have button: register" do
    get :createInstructorForm
  	assert_select "button", "Register!"
  end

  test "create new instructor" do
  	get :createNewInstructor

  end

end
