require "test_helper"

class ActivityLogTest < ActiveSupport::TestCase
  test "requires an action" do
    activity_log = activity_logs(:one)
    activity_log.action = nil

    refute activity_log.valid?
    assert_includes activity_log.errors[:action], "can't be blank"
  end
end
