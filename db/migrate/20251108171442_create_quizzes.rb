class CreateQuizzes < ActiveRecord::Migration[8.1]
  def change
    create_table :quizzes do |t|
      t.string :code, null: false, index: { unique: true }
      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps
    end
  end
end
