# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :find_quiz, only: %i[show next]

  def show
    @is_host = session[:hosting] == params[:quiz_id]
    @player = @quiz.players.find_by(id: session[:player_id])
  end

  def buzz
    # log time first to avoid lag from db requests
    buzzed_at = Time.current
    @quiz = Quiz.find_by!(code: params[:quiz_id])
    @player = @quiz.players.find_by!(id: session[:player_id])
    @player.update!(buzzed_at: buzzed_at) if @player.buzzed_at.nil?

    redirect_to quiz_question_path(@quiz)
  end

  def next
    Player.where(quiz: @quiz).update_all(buzzed_at: nil)

    # head :no_content
  end

  private

  def find_quiz
    @quiz = Quiz.find_by!(code: params[:quiz_id])
  end

  def host_only
    return render_404 unless session[:hosting] == params[:id]
  end
end
