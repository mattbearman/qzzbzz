# frozen_string_literal: true

class QuizzesController < ApplicationController
  before_action :find_quiz!, only: %i[show join]
  before_action :find_player, only: %i[show join]
  before_action :no_host, only: %i[show join]

  def index
  end

  def new
  end

  def create
    quiz_params = params.require(:quiz).permit(:name)
    @quiz = Quiz.create!(code: SecureRandom.alphanumeric(6).upcase, name: quiz_params[:name])

    session[:hosting_quiz_id] = @quiz.id

    redirect_to host_quiz_path
  end

  def show
    if @quiz.started? && @player&.quiz_id == @quiz.id
      return redirect_to quiz_question_path(quiz_id: @quiz.code)
    end
  end

  def join
    if @quiz.joinable? && @player&.quiz_id != @quiz.id
      @player = @quiz.players.create!(name: params[:name])
      session[:player_id] = @player.id

      @quiz.broadcast_players
    end

    redirect_to quiz_path(id: params[:id])
  end

  private

  def find_quiz!
    @quiz = Quiz.find_by!(code: params[:id])
  end

  def find_player
    @player = @quiz.players.find_by(id: session[:player_id])
  end

  def no_host
    redirect_to host_quiz_path if session[:hosting_quiz_id] == @quiz.id
  end
end
