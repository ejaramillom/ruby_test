# frozen_string_literal: true

class CreateTins < ActiveRecord::Migration[7.1]
  def change
    create_table :tins do |t|
      t.string :number
      t.string :country
      t.integer :tin_type

      t.timestamps
    end
  end
end
