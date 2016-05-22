require_relative "../test_helper"

class UniqueTest < Minitest::Test
  include TestHelpers
  include Unique
  include PayloadHelpers

  def test_it_can_create_a_sha
    assert_equal "c22b5f9178342609428d6f51b2c5af4c0bde6a42", create_sha("hi")
  end

  def test_it_can_tell_you_if_a_client_exists
    client = make_client
    assert client_sha_exists?(client)
  end

  def test_it_can_tell_you_if_a_client_does_not_exist
    refute client_sha_exists?(Client.create)
  end

  def test_it_can_verify_if_a_client_is_valid
    client = make_client
    assert bad_client?(client)
  end
end
