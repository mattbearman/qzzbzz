# frozen_string_literal: true

lobby = Quiz.create!(code: "LOBBY", name: "Local Test Lobby Quiz")
going = Quiz.create!(code: "GOING", name: "Local Test In-Progress Quiz", started_at: 1.hour.ago)
ended = Quiz.create!(code: "ENDED", name: "Local Test Ended Quiz", started_at: 1.hour.ago, ended_at: 30.minutes.ago)
