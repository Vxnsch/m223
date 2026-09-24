require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "guests cannot view a profile" do
    get profile_url

    assert_redirected_to login_url
  end

  test "logged-in users see only their own profile" do
    user = users(:one)
    log_in_as user

    get profile_url

    assert_response :success
    assert_includes response.body, user.email
    assert_not_includes response.body, users(:admin).email
  end

  test "users can update their own email but not their role" do
    user = users(:one)
    log_in_as user

    patch profile_url, params: {
      user: {
        email: " UPDATED@EXAMPLE.COM ",
        role: "admin"
      }
    }

    assert_redirected_to profile_url
    assert_equal "updated@example.com", user.reload.email
    assert_equal "user", user.role
  end

  private

  def log_in_as(user)
    post login_url, params: {
      email: user.email,
      password: "validpassword12"
    }
  end
end
