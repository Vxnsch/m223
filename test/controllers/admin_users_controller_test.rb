require "test_helper"

class AdminUsersControllerTest < ActionDispatch::IntegrationTest
  test "normal users cannot open user management" do
    log_in_as users(:one)

    get admin_users_url

    assert_redirected_to pages_url
    assert_equal "You are not allowed to perform this action.", flash[:alert]
  end

  test "admins can list users and change a role" do
    log_in_as users(:admin)

    get admin_users_url
    assert_response :success
    assert_includes response.body, users(:one).email

    patch admin_user_url(users(:one)), params: {
      user: { role: "uploader" }
    }

    assert_redirected_to admin_users_url
    assert_equal "uploader", users(:one).reload.role
  end

  private

  def log_in_as(user)
    post login_url, params: {
      email: user.email,
      password: "validpassword12"
    }
  end
end
