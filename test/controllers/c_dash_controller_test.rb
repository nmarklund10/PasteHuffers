require 'test_helper'

class CDashControllerTest < ActionController::TestCase
	test 'requesting with a session should return courses' do
		@request.session["IUID"] = 1
		get :getClasses
		response =JSON.parse(@response.body)
		names = Array.new
		response.each do |element|
			names.push element["name"]
		end
		assert_includes( names, "CSCE 121", 'CSCE 121 is not returned from courses')
		assert_includes( names, "CSCE 222", 'CSCE 222 is not returned from courses')
		assert_includes( names, "CSCE 469", 'CSCE 469 is not returned from courses')
		assert_includes( names, "CSCE 313", 'CSCE 313 is not returned from courses')
		assert_includes( names, "CSCE 314", 'CSCE 314 is not returned from courses')
	end
	test 'requesting without a session should return nil' do
		get :getClasses
		response =JSON.parse(@response.body)
		assert response.length == 0
	end

	test 'createCourseForm uses the correct template' do
		get :createCourseForm
		assert_template layout: "layouts/application"
		assert_template :createCourseForm
	end
	test 'course form should have field: semester' do
		get :createCourseForm
		assert_select "label", "Semester:"
		assert_select "input:match('name', ?)", "semester"
	end
	test 'course form should have field: Course Name' do
		get :createCourseForm
		assert_select "label", "Course Name:"
		assert_select "input:match('name', ?)", "class_name"
	end
	test 'course form should have field: Section' do
		get :createCourseForm
		assert_select "label", "Section:"
		assert_select "input:match('name', ?)", "courseSectionForm"
	end
	test 'course form should have button: Create Course' do
		get :createCourseForm
		assert_select "button", "Create Course"
	end

	test 'create new course should fail without session id' do
		get :createNewCourse, {"name" => "CSCE 123"}
		response = JSON.parse(@response.body)
		assert_equal false, response["success"]
		assert_equal "No User Logged in", response["reason"]
	end
	test 'create new course should fail with empty name' do
		@request.session["IUID"] = 1
		get :createNewCourse
		response = JSON.parse(@response.body)
		assert_equal false, response["success"]
		assert_equal "Need a name", response["reason"]
	end
	test 'create new course should fail with existing name and instructor id' do
		@request.session["IUID"] = 1
		get :createNewCourse, {"name" => "CSCE 121"}
		response = JSON.parse(@response.body)
		assert_equal false, response["success"]
		assert_equal "Course with that name already exists!", response["reason"]
	end
	test 'create new course should succeed with unique name and instructor id' do
		@request.session["IUID"] = 1
		get :createNewCourse, {"name" => "CSCE 123"}
		response = JSON.parse(@response.body)
		assert_equal true, response["success"]

		assert_equal "CSCE 123", response["course"]["name"], "course name not matching"
		assert_equal 1, response["course"]["instructor_id"], "instructor id not matching"
	end
end
