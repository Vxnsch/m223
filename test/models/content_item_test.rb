require "test_helper"

class ContentItemTest < ActiveSupport::TestCase
  test "belongs to its archive page" do
    assert_equal pages(:one), content_items(:one).page
  end
end
