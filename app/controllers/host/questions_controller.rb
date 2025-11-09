# frozen_string_literal: true

module Host
  class QuestionsController < ApplicationController
    before_action :find_quiz
    before_action :find_player!, only: %i[answer correct incorrect]

    def show
    end

    def call_fastest_player
      @player = @quiz.players.fastest(1).first
      @player.call_for_answer if @player

      redirect_to answer_host_quiz_question_path(player_id: @player.id)
    end

    def answer
    end

    def correct
      @player.correct_answer
    end

    def incorrect
      @player.incorrect_answer

      redirect_to host_quiz_question_path
    end

    def next
      @quiz.next_question!

      redirect_to host_quiz_question_path
    end

    private

    def find_quiz
      @quiz = Quiz.find_by(id: session[:hosting_quiz_id])

      redirect_to root_path unless @quiz.present?
    end

    def find_player!
      @player = @quiz.players.find_by!(id: params[:player_id])
    end
  end
end
