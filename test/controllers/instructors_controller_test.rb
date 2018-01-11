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
<<<<<<< HEAD

  test "create new instructor" do
  	get :createNewInstructor

=======
  test "should fail: register with insufficient data" do
  	get :createNewInstructor, {'name' => 'SomeGuy', 'email' => 'SomeGuy'}
  	response = JSON.parse(@response.body)
  	assert_equal false, response['success']
  	assert_equal "Insufficient Data Provided!", response['reason']
  end
  test "should fail: register with existing name" do
  	get :createNewInstructor, {'name' => 'SomeGuy', 'email' => 'SomeGuy', 'password' => 123456}
  	response = JSON.parse(@response.body)
  	assert_equal false, response['success']
  	assert_equal "Instructor with that name already exists!", response['reason']
  end
  test "should fail: register with existing email" do
  	get :createNewInstructor, {'name' => 'SomeGuy2', 'email' => 'someguy@someguy.com', 'password' => 123456}
  	response = JSON.parse(@response.body)
  	assert_equal false, response['success']
  	assert_equal "Instructor with that email already exists!", response['reason']
  end
  test "should succeed: register" do
  	get :createNewInstructor, {'name' => 'SomeGuy2', 'email' => 'someguy2@someguy.com', 'password' => 123456}
  	response = JSON.parse(@response.body)
  	assert_equal true, response['success']
  	assert_equal true, (Instructor.where(name: 'SomeGuy2').length == 1)
>>>>>>> 2c04bef6ec4ae8f6dca7fae8f6cb4e55e947f156
  end
end
