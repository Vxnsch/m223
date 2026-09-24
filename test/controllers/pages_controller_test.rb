require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "redirects guests to login" do
    get pages_url

    assert_redirected_to login_url
  end

  test "shows the index to logged-in users" do
    user = users(:one)
    post login_url, params: {
      email: user.email,
      password: "validpassword12"
    }

    get pages_url

    assert_response :success
  end
  test "search filters pages by title" do
    user = users(:one)

    post login_url, params: {
      email: user.email,
      password: "validpassword12"
    }

    get pages_url, params: { query: "Jordan" }

    assert_response :success
    assert_includes response.body, "Air Jordan 1"
    assert_not_includes response.body, "Nike Air Max 95"
  end
  test "shows an archive page with its information" do
    user = users(:one)

    post login_url, params: {
      email: user.email,
      password: "validpassword12"
    }

    get page_url(pages(:one))

    assert_response :success
    assert_select "h1", "Air Jordan 1"
    assert_includes response.body, "first released in 1985"
    assert_select "a[href='https://www.ebay.ch/sch/i.html?_nkw=Air+Jordan+1&_sacat=0&_from=R40&_trksid=p4624852.m570.l1313']"
  end

  test "normal users cannot create archive pages" do
    log_in_as users(:one)

    get new_page_url

    assert_redirected_to pages_url
    assert_equal "You are not allowed to perform this action.", flash[:alert]
  end

  test "uploaders create a page and its information together" do
    log_in_as users(:two)

    assert_difference("Page.count", 1) do
      assert_difference("ContentItem.count", 1) do
        post pages_url, params: {
          page: {
            title: "Yeezy Boost 350",
            content_items_attributes: {
              "0" => {
                content_type: "description",
                text: "A collaborative sneaker.",
                url: "https://example.com/yeezy",
                datetime: "2015-06-27"
              }
            }
          }
        }
      end
    end

    created_page = Page.find_by!(title: "Yeezy Boost 350")
    assert_equal users(:two), created_page.user
    assert_redirected_to page_url(created_page)
  end

  test "admins can delete archive pages" do
    log_in_as users(:admin)
    page = pages(:one)

    assert_difference("Page.count", -1) do
      delete page_url(page)
    end

    assert_redirected_to pages_url
  end

  private

  def log_in_as(user)
    post login_url, params: {
      email: user.email,
      password: "validpassword12"
    }
  end
end
