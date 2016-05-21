require_relative '../models/unique'
require_relative '../models/payload_creator'
require_relative '../models/response_messages'

module RushHour
  class Server < Sinatra::Base
    include Unique
    include PayloadCreator
    include ResponseMessages

    not_found do
      erb :error
    end

    get '/sources/:identifier' do |identifier|
      if Client.exists?(identifier: identifier)
        @client =  Client.find_by(identifier: identifier)
        if @client.payload_requests.empty?
          @error_string = "Client #{identifier} does not have any associated payload requests."
          erb :error
        else
          erb :'clients/show'
        end
      else
        @error_string = "#{identifier} does not exist."
        erb :error
      end
    end

    post '/sources/:identifier/data' do |identifier|
      payload = create_new_payload(params, identifier)
      payload_response_decider(payload)
    end

    post '/sources' do
      client_response_decider(params)
    end
  end
end
