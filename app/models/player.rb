# frozen_string_literal: true

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

    broadcast_update target: "quiz", html: '<div class="text-center text-9xl">✅</div>'.html_safe
  end

  def incorrect_answer
    update!(buzzed_at: nil)

    broadcast_update target: "quiz", html: '<div class="text-center text-9xl">❌</div>'.html_safe
  end
end
