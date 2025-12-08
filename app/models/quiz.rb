# frozen_string_literal: true

# == Schema Information
#
# Table name: quizzes
#
#  id                          :integer          not null, primary key
#  code                        :string           not null
#  current_question            :integer          default(0), not null
#  ended_at                    :datetime
#  name                        :string           not null
#  started_at                  :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  currently_calling_player_id :integer
#
# Indexes
#
#  index_quizzes_on_code                         (code) UNIQUE
#  index_quizzes_on_currently_calling_player_id  (currently_calling_player_id)
#
# Foreign Keys
#
#  currently_calling_player_id  (currently_calling_player_id => players.id)
#

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
    broadcast_update target: "players_joined", partial: "shared/players_joined", locals: { quiz: self }
  end

  def broadcast_buzzed_players
    buzzed_players = players.where.not(buzzed_at: nil).order(:buzzed_at)
    broadcast_update target: "players_buzzed", partial: "host/questions/players_buzzed", locals: { quiz: self }
  end

  def broadcast_calling_player
    broadcast_update target: "spectator", partial: "spectators/calling_player", locals: { quiz: self }
  end

  def start!
    return if started?

    update!(started_at: Time.current, current_question: 1)
    broadcast_update target: "quiz", partial: "questions/buzz", locals: { quiz: self }
    broadcast_update target: "spectator", partial: "spectators/question", locals: { quiz: self }
  end

  def next_question!
    return unless in_progress?

    increment!(:current_question)
    players.update_all(buzzed_at: nil, locked_out: false)

    broadcast_update target: "quiz", partial: "questions/buzz", locals: { quiz: self }
    broadcast_update target: "spectator", partial: "spectators/question", locals: { quiz: self }
  end

  def end!
    return if ended?

    update!(ended_at: Time.current)

    players.find_each do |player|
      next if player == winner

      player.broadcast_update target: "quiz", partial: "quizzes/ended", locals: { quiz: self }
    end

    winner&.broadcast_update target: "quiz", partial: "quizzes/winner"
    broadcast_update target: "spectator", partial: "spectators/finished", locals: { quiz: self }
  end
end
