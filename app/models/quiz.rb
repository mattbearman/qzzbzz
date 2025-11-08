# frozen_string_literal: true

class Quiz < ApplicationRecord
  has_many :players, dependent: :destroy

  scope :joinable, -> { where(started_at: nil, ended_at: nil) }

  def to_param
    code
  end

  def joinable?
    started_at.nil? && ended_at.nil?
  end
end
