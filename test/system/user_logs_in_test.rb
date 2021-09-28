require "application_system_test_case"

class UserLogsInTest < ApplicationSystemTestCase
    test "navigate to the homepage" do
        @testuser = users(:testuser)

        # attempt to navigate to the root path, and get redirected
        # to the login page
        visit root_path
        assert_current_path new_user_session_path

        # log in
        fill_in 'Email', with: @testuser.email
        fill_in 'Password', with: "testuser"
        click_button 'Log in'
        assert_current_path root_path
    end
end
