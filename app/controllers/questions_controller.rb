# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :find_quiz!, only: %i[show]
  before_action :no_host

  def show
    @player = @quiz.players.find_by(id: session[:player_id])
  end

  def buzz
    # log time first to avoid lag from db requests
    buzzed_at = Time.current
    @quiz = Quiz.find_by!(code: params[:quiz_id])
    @player = @quiz.players.find_by!(id: session[:player_id])
    @player.update!(buzzed_at: buzzed_at) if @player.buzzed_at.nil?
    @quiz.broadcast_buzzed_players

    redirect_to quiz_question_path(@quiz)
  end

  private

  def find_quiz!
    @quiz = Quiz.find_by!(code: params[:quiz_id])
  end

  def no_host
    redirect_to host_quiz_path if session[:hosting_quiz_id] == params[:quiz_id]
  end
end
