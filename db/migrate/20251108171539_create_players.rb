class CreatePlayers < ActiveRecord::Migration[8.1]
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.belongs_to :quiz, null: false, foreign_key: true
      t.datetime :buzzed_at
      t.integer :score, null: false, default: 0
      t.timestamps
    end
  end
end
