# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :quiz

  scope :fastest, ->(limit) { buzzed_in.limit(limit) }
  scope :buzzed_in, -> { where.not(buzzed_at: nil).order(:buzzed_at) }

  def call_for_answer
    broadcast_update target: "quiz", html: "<h2>#{name}, please answer!</h2>".html_safe
  end

  def correct_answer
    increment!(:score)
    update!(buzzed_at: nil)

    broadcast_update target: "quiz", html: "<h2>Correct answer, #{name}!</h2>".html_safe
  end

  def incorrect_answer
    update!(buzzed_at: nil)

    broadcast_update target: "quiz", html: "<h2>Incorrect answer, #{name}.</h2>".html_safe
  end
end
