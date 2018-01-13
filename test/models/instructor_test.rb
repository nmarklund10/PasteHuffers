require 'test_helper'

class InstructorTest < ActiveSupport::TestCase
  test "empty instructor" do
    instructor = Instructor.new
    assert_not instructor.save , "Instructor created without data"
  end
end
