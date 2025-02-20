# frozen_string_literal: true

class Tin < ApplicationRecord
  attr_accessor(*%i[valid formatted_tin business_registration])

  enum tin_type: { au_abn: 0, au_acn: 1, ca_gst: 2, in_gst: 3 }

  validates_with TinValidator

  # def initialize(attributes = {})
  #   attributes.each do |key, value|
  #     send("#{key}=", value) if respond_to?("#{key}=")
  #   end
  # end
end
