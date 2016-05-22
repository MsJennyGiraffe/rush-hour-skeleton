require_relative "../test_helper"

class UserCanGitInformationAboutAClientRelativePath < FeatureTest

  def test_user_can_get_information_about_a_client_relative_path
    make_payload_request

    visit "/sources/google/urls/about"

    within(".table") do
      assert page.has_content?("google")
      assert page.has_content?("20")
      assert page.has_content?("GET")
      assert page.has_content?("www.google.com")
      assert page.has_content?("Intel Mac OS X 10.8.2")
      assert page.has_content?("Mozilla/5.0")
    end
  end

  def test_if_identifier_does_not_exist_user_sees_error
    make_payload_request

    visit "/sources/google/urls/i_made_this_up"
    assert page.has_content?("www.google.com/i_made_this_up does not exist.")
  end

  def test_it_displays_an_error_if_the_client_does_not_exist
    visit "/sources/dne"

    assert page.has_content?("dne does not exist.")
  end
end
