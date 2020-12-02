# frozen_string_literal: true

class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.string :email
      t.references :book, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
