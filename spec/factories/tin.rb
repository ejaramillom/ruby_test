# frozen_string_literal: true

FactoryBot.define do
  factory :tin do
    country { 'CA' }
    number { '123456789' }
    valid { false }
    formatted_tin { nil }
    tin_type { nil }

    trait :au_abn do
      country { 'AU' }
      number { '10120000004' }
    end

    trait :au_acn do
      country { 'AU' }
      number { '123456789' }
    end

    trait :ca_gst do
      country { 'CA' }
      number { '123456789' }
    end

    trait :in_gst do
      country { 'IN' }
      number { '12ABCDE1234F1Z5' }
    end
  end
end
