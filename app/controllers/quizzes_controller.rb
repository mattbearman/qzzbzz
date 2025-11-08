# frozen_string_literal: true

class QuizzesController < ApplicationController
  before_action :host_only, only: %i[start next_question end]

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

    Turbo::StreamsChannel.broadcast_update_to "quizzes_#{params[:id]}", target: "players", html: @quiz.players.map { |p| "<li>#{p.name}</li>" }.join.html_safe
  end

  def start
    @quiz = Quiz.find_by!(code: params[:id])
    @quiz.update!(started_at: Time.current)

    Turbo::StreamsChannel.broadcast_update_to "quizzes_#{params[:id]}", target: "quiz_status", html: "<p>Quiz Started!</p>".html_safe

    redirect_to quiz_path(@quiz)
  end

  def buzz
    buzzed_at = Time.current
    @quiz = Quiz.find_by!(code: params[:id])
    @player = @quiz.players.find_by!(id: session[:player_id])
    @player.update!(buzzed_at: buzzed_at)

    # head :no_content
  end

  def next_question
    @quiz = Quiz.find_by!(code: params[:id])

    Turbo::StreamsChannel.broadcast_update_to "quizzes_#{params[:id]}", target: "quiz_status", html: "<p>Quiz Ended!</p>".html_safe
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
