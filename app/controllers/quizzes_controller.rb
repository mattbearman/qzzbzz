# frozen_string_literal: true

class QuizzesController < ApplicationController
  def new
  end

  def create
    quiz_params = params.require(:quiz).permit(:name)
    @quiz = Quiz.create!(code: SecureRandom.alphanumeric(6).upcase, name: quiz_params[:name])

    session[:hosting] = @quiz.code

    redirect_to host_quiz_path
  end

  def show
    # TOOD: NO hosts

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
end
