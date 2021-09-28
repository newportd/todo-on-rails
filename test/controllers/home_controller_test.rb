require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should login successfully" do
    @testuser = users(:testuser)

    # when not authenticated the user is redirected to login
    get home_index_url
    assert_redirected_to new_user_session_path

    # login using testuser
    post new_user_session_path, params: { user: { email: @testuser.email, password: "testuser" } }
    assert_redirected_to home_index_url

    # validate the successful login message displays
    assert_equal I18n.t("devise.sessions.signed_in"), flash[:notice]
  end
end
