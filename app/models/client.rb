class Client < ActiveRecord::Base
  has_many :payload_requests

  has_many :urls, through: :payload_requests
  has_many :referred_bies, through: :payload_requests
  has_many :request_types, through: :payload_requests
  has_many :user_agent_infos, through: :payload_requests
  has_many :screen_sizes, through: :payload_requests
  has_many :ips, through: :payload_requests
  has_many :events, through: :payload_requests

  validates :identifier, presence: true
  validates :root_url, presence: true
end
