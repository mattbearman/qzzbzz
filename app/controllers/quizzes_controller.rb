# frozen_string_literal: true

class QuizzesController < ApplicationController
  before_action :host_only, only: %i[start end]

  def new
  end

  def create
    @quiz = Quiz.create!(code: SecureRandom.alphanumeric(8).upcase)

    session[:hosting] = @quiz.code

    redirect_to quiz_path(@quiz)
  end

  def show
    @is_host = session[:hosting] == params[:id]
    @quiz = Quiz.find_by(code: params[:id])
    # return render_404 unless @quiz
  end

  def join
    redirect_to quiz_path(id: params[:id]) if session[:hosting] == params[:id]

    @quiz = Quiz.find_by(code: params[:id])

    # TODO Show a 404 if quiz not found
    # return render_404 unless @quiz

    return redirect_to quiz_path(id: params[:id]) unless @quiz.joinable?

    @player = @quiz.players.create!(name: params[:name])
    session[:player_id] = @player.id

    @quiz.broadcast_players
  end

  def start
    @quiz = Quiz.find_by!(code: params[:id])
    @quiz.start!

    redirect_to quiz_question_path(@quiz)
  end

  def end
    @quiz = Quiz.find_by!(code: params[:id])
    @quiz.update!(ended_at: Time.current)

    Turbo::StreamsChannel.broadcast_update_to "quizzes_#{params[:id]}", target: "quiz_status", html: "<p>Quiz Ended!</p>".html_safe

    redirect_to quiz_path(@quiz)
  end

  private

  def host_only
    redirect_to quiz_path(id: params[:id]) unless session[:hosting] == params[:id]
  end
end
