# frozen_string_literal: true

module V1
  class TinController < ApplicationController

  def validator

  end

  private

  def tin_params
    params.permit(:country, :number)
  end

  end
end
