require 'digest'
require 'net/http'

module Unique
  def create_sha(params)
    Digest::SHA1.hexdigest params.to_s
  end

  def client_sha_exists?(object)
    Client.exists?(sha: object.sha)
  end

  def payload_sha_exists?(object)
    PayloadRequest.exists?(sha: object.sha)
  end

  def bad_client?(identifier)
    !Client.find_by(identifier: identifier).present?
  end

end
