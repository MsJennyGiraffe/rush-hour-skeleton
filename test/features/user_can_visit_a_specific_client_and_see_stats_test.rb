require_relative "../test_helper"

class UserCanVisitASpecificClientAndSeeStats < FeatureTest

  def test_user_can_visit_a_specific_client_and_see_stats
    make_payload_request

    visit "/sources/google"

    within(".table") do
      assert page.has_content?("google")
      assert page.has_content?("20 milliseconds")
      assert page.has_content?("GET")
      assert page.has_content?("www.google.com/about")
      assert page.has_content?("Mozilla/5.0")
      assert page.has_content?("Intel Mac OS X")
      assert page.has_content?("1080 x 900")
    end
  end
end
