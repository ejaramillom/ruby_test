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
    parsed_body = build_business_properties(response)

    parse_response(parsed_body)
  end

  def parse_response(business)
    case business[:code]
    when '200' then { body: business[:business_registration], error: nil }
    when '404' then { body: business[:business_registration], error: 'Business is not registered' }
    when '500' then { body: business[:business_registration], error: 'Registration API could not be reached' }
    else { body: business[:business_registration], error: 'Unknown error' }
    end
  end

  def build_business_properties(response)
    code = response.code
    properties = Nokogiri::XML(response.body)

    name = properties.at_xpath('//businessEntity/organisationName').content
    state = properties.at_xpath('//businessEntity/address/stateCode').content
    postcode = properties.at_xpath('//businessEntity/address/postcode').content

    {
      code: code,
      business_registration: {
        name: name,
        address: "#{state}, #{postcode}"
      }
    }
  end
end
