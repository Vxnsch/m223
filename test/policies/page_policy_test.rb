require "test_helper"

class PagePolicyTest < ActiveSupport::TestCase
  test "roles receive only their documented page permissions" do
    page = pages(:one)

    user_policy = PagePolicy.new(users(:one), page)
    assert user_policy.show?
    refute user_policy.create?
    refute user_policy.destroy?

    uploader_policy = PagePolicy.new(users(:two), page)
    assert uploader_policy.show?
    assert uploader_policy.create?
    refute uploader_policy.destroy?

    admin_policy = PagePolicy.new(users(:admin), page)
    assert admin_policy.show?
    assert admin_policy.create?
    assert admin_policy.destroy?
  end
end
