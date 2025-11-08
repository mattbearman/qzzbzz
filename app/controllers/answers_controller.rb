# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :find_quiz
  before_action :host_only

  def index
  end

  def show
    @player = @quiz.players.find_by!(id: params[:id])
  end

  def call_fastest_player
    @player = @quiz.players.fastest(1).first
    @player.call_for_answer if @player

    redirect_to quiz_answer_path(@quiz, @player)
  end

  def correct
    @player = @quiz.players.find_by!(id: params[:id])
    @player.correct_answer
  end

  def incorrect
    @player = @quiz.players.find_by!(id: params[:id])
    @player.incorrect_answer

    redirect_to quiz_answers_path
  end

  private

  def find_quiz
    @quiz = Quiz.find_by!(code: params[:quiz_id])
  end

  def host_only
    redirect_to root_path unless session[:hosting] == @quiz.code
  end
end
