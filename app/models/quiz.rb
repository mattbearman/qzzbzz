# frozen_string_literal: true

class Quiz < ApplicationRecord
  has_many :players, dependent: :destroy

  def to_param
    code
  end

  def joinable?
    started_at.nil? && ended_at.nil?
  end

  def broadcast_players
    broadcast_update target: "players", html: players.map { |p| "<li>#{p.name}</li>" }.join.html_safe
  end

  def start!
    return if started_at.present?

    update!(started_at: Time.current)
    broadcast_update target: "quiz", template: "questions/_buzz", locals: { quiz: self }
  end

  def next_question!
    players.update_all(buzzed_at: nil)

    broadcast_update target: "quiz", template: "questions/_buzz", locals: { quiz: self }
  end
end
