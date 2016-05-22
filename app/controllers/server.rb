require_relative '../models/unique'
require_relative '../models/payload_creator'
require_relative '../models/response_decider'

module RushHour
  class Server < Sinatra::Base
    include Unique
    include PayloadCreator
    include ResponseDecider

    not_found do
      erb :error
    end

    get '/sources/:identifier' do |identifier|
      client_response_decider(identifier)
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      urls_response_decider(identifier, relative_path)
    end

    post '/sources/:identifier/data' do |identifier|
      payload = create_new_payload(params, identifier)
      payload_response_decider(payload, identifier)
    end

    post '/sources' do
      client_response_decider(params)
    end

    get '/sources/:identifier/events' do |identifier|
      client_index_response_decider(identifier)
    end

    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      events_response_decider(identifier, event_name)
    end
  end
end
