# frozen_string_literal: true

class AddLockedOutToPlayer < ActiveRecord::Migration[8.1]
  def change
    add_column :players, :locked_out, :boolean, default: false, null: false
  end
end
