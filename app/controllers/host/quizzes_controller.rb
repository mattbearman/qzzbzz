# frozen_string_literal: true

module Host
  class QuizzesController < ApplicationController
    before_action :find_quiz

    def show
      return redirect_to host_quiz_question_path if @quiz.in_progress?
      @join_link = "http://#{`ipconfig getifaddr en0`.chomp}:3000/quiz/join/#{@quiz.code}"
    end

    def start
      @quiz.start!

      redirect_to host_quiz_question_path
    end

    def end
      @quiz.end!

      redirect_to host_quiz_path
    end

    private

    def find_quiz
      @quiz = Quiz.find_by(id: session[:hosting_quiz_id])

      redirect_to root_path unless @quiz.present?
    end
  end
end
