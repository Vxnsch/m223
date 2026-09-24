require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "shows the login form" do
    get login_url

    assert_response :success
  end

  test "logs in with valid credentials regardless of email casing" do
    post login_url, params: {
      email: " ONE@EXAMPLE.COM ",
      password: "validpassword12"
    }

    assert_redirected_to pages_url

    get pages_url
    assert_response :success
  end

  test "logged-in users are redirected away from the login form" do
    post login_url, params: {
      email: @user.email,
      password: "validpassword12"
    }

    get login_url

    assert_redirected_to pages_url
  end

  test "rejects invalid credentials with feedback" do
    post login_url, params: {
      email: @user.email,
      password: "wrong-password"
    }

    assert_response :unprocessable_entity
    assert_equal "Invalid email or password", flash[:alert]
  end

  test "logout removes access to protected pages" do
    post login_url, params: {
      email: @user.email,
      password: "validpassword12"
    }

    delete logout_url
    assert_redirected_to root_url

    get pages_url
    assert_redirected_to login_url
  end
end
