# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Instructor.create(name:"SomeGuy", email:"someguy@someguy.com")
Course.create(name:"MATH", instructor_id:0)
Course.create(name:"Science", instructor_id:0)
Course.create(name:"English", instructor_id:0)