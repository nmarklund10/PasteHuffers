require 'rails_helper'

describe "the signin process", :type => :feature, js:true do
	it "registers with no errors" do
		visit '/'
		click_button('createInstructorButton', wait: 5)
		screenshot_and_save_page
		Capybara.within_frame 'dijit_Dialog_0' do
			fill_in 'instrName', with: 'John Doe'
			# find('instrName', :visible => false).set('John Doe')
			fill_in 'instrEmail', with: 'johndoe@tamu.edu.com'
			fill_in 'instrPassword', with: '123456'
			fill_in 'password_validate', with: '123456'
			click_button 'submitInstructorButton_label'
		end
		expect(page).to have_content 'Welcome Instructor.'
	end

	it "signs in - no errors" do
		visit '/'
		# fill_in 'type=text', with: 'SomeGuy'
		# fill_in 'password', with: '1234'
		find('input[type="text"]').set('SomeGuy')
		find('input[type=password]').set('1234')
		screenshot_and_save_page
		find_button("loginButton").trigger('click')
		
		screenshot_and_save_page
		expect(page).to have_content 'Welcome Instructor.'
	end
end
