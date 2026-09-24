require "test_helper"

class AdminActivityLogsControllerTest < ActionDispatch::IntegrationTest
  test "normal users cannot view activity logs" do
    log_in_as users(:one)

    get admin_activity_logs_url

    assert_redirected_to pages_url
  end

  test "admins can view activity logs" do
    log_in_as users(:admin)

    get admin_activity_logs_url

    assert_response :success
    assert_includes response.body, "login"
    assert_includes response.body, users(:admin).email
  end

  private

  def log_in_as(user)
    post login_url, params: {
      email: user.email,
      password: "validpassword12"
    }
  end
end
