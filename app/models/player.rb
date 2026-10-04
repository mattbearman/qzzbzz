# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  buzzed_at  :datetime
#  locked_out :boolean          default(FALSE), not null
#  name       :string           not null
#  score      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quiz_id    :integer          not null
#
# Indexes
#
#  index_players_on_quiz_id  (quiz_id)
#
# Foreign Keys
#
#  quiz_id  (quiz_id => quizzes.id)
#

class Player < ApplicationRecord
  belongs_to :quiz

  scope :fastest, ->(limit) { buzzed_in.limit(limit) }
  scope :buzzed_in, -> { where.not(buzzed_at: nil).order(:buzzed_at) }

  def call_for_answer
    quiz.update!(currently_calling_player: self)
    broadcast_update target: "quiz", partial: "questions/called"
  end

  def correct_answer
    increment!(:score)
    update!(buzzed_at: nil)
    quiz.update!(currently_calling_player: nil)

    broadcast_update target: "quiz", partial: "questions/correct"
  end

  def incorrect_answer
    update!(buzzed_at: nil, locked_out: true)
    quiz.update!(currently_calling_player: nil)

    broadcast_update target: "quiz", partial: "questions/incorrect"
  end
end
