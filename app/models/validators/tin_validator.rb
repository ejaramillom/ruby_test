# frozen_string_literal: true

class TinValidator < ActiveModel::Validator
  def validate(record)
    return missing_country_input(record) unless record.country
    return missing_number_input(record) unless record.number

    @normalized_number = record.number.gsub(' ', '')
    case record.country.downcase
    when 'au' then validate_au(record)
    when 'ca' then validate_ca(record)
    when 'in' then validate_in(record)
    else record.errors.add 'Country not found for validation. Please try again with a different value. '
    end
  end

  private

  def validate_au(record)
    return add_invalid_au_error(record) unless au_abn?(@normalized_number) || au_acn?(@normalized_number)

    record.valid = true
    record.tin_type, record.formatted_tin = determine_au_tin_variation(@normalized_number)
  end

  def validate_ca(record)
    return add_invalid_ca_error(record) unless ca_gst?(@normalized_number)

    record.valid = true
    record.tin_type = :ca_gst
    record.formatted_tin = "#{@normalized_number[0..8]}RT0001"
  end

  def validate_in(record)
    return add_invalid_in_error(record) unless in_gst?(@normalized_number)

    record.valid = true
    record.tin_type = :in_gst
    record.formatted_tin = @normalized_number.upcase
  end

  def determine_au_tin_variation(number)
    if number.length == 11
      [:au_abn, "#{number[0..1]} #{number[2..4]} #{number[5..7]} #{number[8..10]}"]
    else
      [:au_acn, "#{number[0..2]} #{number[3..5]} #{number[6..8]}"]
    end
  end

  def au_abn?(number)
    number.match?(/^\d{11}$/)
  end

  def au_acn?(number)
    number.match?(/^\d{9}$/)
  end

  def ca_gst?(number)
    number.match?(/^\d{9}(RT0001)?$/)
  end

  def in_gst?(number)
    number.match?(/\d{2}[A-Z0-9]{10}\d[A-Z]\d/)
  end

  def add_invalid_au_error(record)
    record.errors.add 'Australian tax identifications are either 9 or 11 numbers long, and only digits. Please verify.'
  end

  def add_invalid_ca_error(record)
    record.errors.add 'Canadian tax identifications are 9 numbers long ending in RT0001 (input the numbers alone). Please verify.'
  end

  def add_invalid_in_error(record)
    record.errors.add 'Indian tax identifications are 15 digits: 2 numbers, 10 alphanumerics, 1 number, 1 letter and 1 number long. Please verify.'
  end

  def missing_country_input(record)
    record.errors.add 'A country must be specified on the request. Please try again.'
  end

  def missing_number_input(record)
    record.errors.add 'A number must be specified on the request. Please try again.'
  end
end
