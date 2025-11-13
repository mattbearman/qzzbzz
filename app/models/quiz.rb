# frozen_string_literal: true

class Quiz < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :questions, dependent: :destroy
  belongs_to :currently_calling_player, class_name: "Player", optional: true

  def to_param
    code
  end

  def joinable?
    !started? && !ended?
  end

  def in_progress?
    started? && !ended?
  end

  def started?
    started_at.present?
  end

  def ended?
    ended_at.present?
  end

  def winner
    players.order(score: :desc).first
  end

  def broadcast_players
    broadcast_update target: "players_joined", template: "host/quizzes/_players_joined", locals: { quiz: self }
  end

  def broadcast_buzzed_players
    buzzed_players = players.where.not(buzzed_at: nil).order(:buzzed_at)
    broadcast_update target: "players_buzzed", template: "host/questions/_players_buzzed", locals: { quiz: self }
  end

  def start!
    return if started?

    update!(started_at: Time.current, current_question: 1)
    broadcast_update target: "quiz", template: "questions/_buzz", locals: { quiz: self }
  end

  def next_question!
    return unless in_progress?

    increment!(:current_question)
    players.update_all(buzzed_at: nil)

    broadcast_update target: "quiz", template: "questions/_buzz", locals: { quiz: self }
  end

  def end!
    return if ended?

    update!(ended_at: Time.current)

    broadcast_update target: "quiz", html: "<h2>Quiz Ended!</h2>".html_safe
  end
end
