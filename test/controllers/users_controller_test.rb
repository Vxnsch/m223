require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "shows the registration form" do
    get new_user_url

    assert_response :success
  end

  test "logged-in users are redirected away from registration" do
    user = users(:one)
    post login_url, params: {
      email: user.email,
      password: "validpassword12"
    }

    get new_user_url

    assert_redirected_to pages_url
  end

  test "creates a user with the default user role" do
    assert_difference("User.count", 1) do
      post users_url, params: {
        user: {
          email: " NEW@EXAMPLE.COM ",
          password: "validpassword12",
          password_confirmation: "validpassword12"
        }
      }
    end

    created_user = User.find_by!(email: "new@example.com")
    assert_equal "user", created_user.role
    assert_redirected_to root_url
  end

  test "rejects a duplicate email" do
    assert_no_difference("User.count") do
      post users_url, params: {
        user: {
          email: "ONE@EXAMPLE.COM",
          password: "validpassword12",
          password_confirmation: "validpassword12"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_includes response.body, "This email is already registered."
  end

  test "rejects a password shorter than twelve characters" do
    assert_no_difference("User.count") do
      post users_url, params: {
        user: {
          email: "short@example.com",
          password: "short",
          password_confirmation: "short"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_includes response.body, "Password is too short"
  end

  test "rejects mismatching passwords" do
    assert_no_difference("User.count") do
      post users_url, params: {
        user: {
          email: "mismatch@example.com",
          password: "validpassword12",
          password_confirmation: "differentpass12"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_includes response.body, "Passwords aren't matching."
  end
end
