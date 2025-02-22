# frozen_string_literal: true

class GstClient
  require 'net/http'

  def initialize(record)
    @record = record
  end

  def call
    fetch_gst_validation(@record)
  end

  private

  def fetch_gst_validation(record)
    uri = URI("http://localhost:8080/queryABN?abn=#{record.number}")
    headers = { 'Content-Type' => 'application/json' }
    response = Net::HTTP.get_response(uri, headers)

    parse_response(response)
  end

  def parse_response(response)
    case response.code
    when '200' then { body: response.body, error: nil }
    when '404' then { body: response.body, error: 'Business is not registered' }
    when '500' then { body: response.body, error: 'Registration API could not be reached' }
    else { body: response.body, error: 'Unknown error' }
    end
  end
end
