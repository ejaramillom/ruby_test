# frozen_string_literal: true

class V1::TinController < ApplicationController
  def validator
    @tin = Tin.new(tin_params)

    if @tin.valid?
      success_response(@tin)
    else
      failure_response(@tin)
    end
  end

  private

  def tin_params
    params.permit(:country, :number)
  end
end
