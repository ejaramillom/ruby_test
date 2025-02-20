# frozen_string_literal: true

class ApplicationController < ActionController::API
  def success_response(record)
    render json: {
      valid: false,
      tin_type: record.tin_type,
      formatted_tin: record.formatted_tin,
      business_registration: record.business_registration
    }, status: :ok
  end

  def failure_response(record)
    render json: {
      valid: false,
      record: record,
      errors: record.errors.uniq
    }, status: :unprocessable_entity
  end
end
