# frozen_string_literal: true

class CreateQuizzes < ActiveRecord::Migration[8.1]
  def change
    create_table :quizzes do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :name, null: false
      t.integer :current_question, default: 0, null: false
      t.references :currently_calling_player, foreign_key: { to_table: :players }
      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps
    end
  end
end
