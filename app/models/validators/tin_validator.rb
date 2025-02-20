# frozen_string_literal: true

class TinValidator < ActiveModel::Validator
  COUNTRIES = %s(au ca in)
  def validate(record)
    unless COUNTRIES.include?(record.country.downcase)
      return records.error.add 'Country does not exist for TIN generation'
    end

    return validate_au(record) if record.country.downcase == 'au'
    return validate_ca(record) if record.country.downcase == 'ca'

    validate_in(record) if record.country.downcase == 'in'
  end

  private

  def validate_au(record)
    unless au_abn?(record) || au_acn?(record)
      return record.errors.add 'Australian tax identifications are either 9 or 11 numbers long, and only digits. Please verify.'
    end

    record.valid = true

    if au_abn?(record)
      record.tin_type = :au_abn

      return record.formatted_tin = "#{record.number[0..1]} #{record.number[2..4]} #{record.number[5..7]} #{record.number[8..10]}"
    end

    record.tin_type = :au_acn
    record.formatted_tin = "#{@tin[0..2]} #{@tin[3..5]} #{@tin[6..8]}"
  end

  def validate_ca(record)
    record
  end

  def validate_in(record)
    record
  end

  def au_abn?(record)
    record.number.match?(/^\d{11}$/)
  end

  def au_acn?(record)
    record.number.match?(/^\d{9}$/)
  end

  def ca_gst?(record)
    record.number.match?(/^\d{10}$/)
  end

  def in_gst?(record)
    record.number.match?(/\d{2}[A-Z0-9]{10}\d[A-Z]\d/)
  end
end





# RULES = {
#   'au' => {
#     au_abn: [/^\d{11}$/, 11],
#     au_acn: [/^\d{9}$/, 9],
#   },
#   'ca' =>{
#     ca_gst: [/^\d{9}$/, 9]
#   },
#   'in' =>{
#     in_gst: [/\d{2}[A-Z0-9]{10}\d[A-Z]\d/, 15]
#   }
# }
