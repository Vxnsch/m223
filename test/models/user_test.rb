require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "rejects roles outside the documented allowlist" do
    user = users(:one)
    user.role = "owner"

    refute user.valid?
    assert_includes user.errors[:role], "is not included in the list"
  end
end
