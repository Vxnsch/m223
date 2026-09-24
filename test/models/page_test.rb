require "test_helper"

class PageTest < ActiveSupport::TestCase
  test "requires a title" do
    page = pages(:one)
    page.title = ""

    refute page.valid?
    assert_includes page.errors[:title], "can't be blank"
  end

  test "supports an attached image" do
    page = pages(:one)

    File.open(Rails.root.join("docs/ERM.png")) do |file|
      page.image.attach(
        io: file,
        filename: "erm.png",
        content_type: "image/png"
      )
    end

    assert page.image.attached?
  end
end
