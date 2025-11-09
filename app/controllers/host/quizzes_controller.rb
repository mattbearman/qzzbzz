# frozen_string_literal: true

module Host
  class QuizzesController < ApplicationController
    before_action :find_quiz

    def show
      @join_link = "http://#{`ipconfig getifaddr en0`.chomp}:3000/quizzes/#{@quiz.code}"
      join_qr = RQRCode::QRCode.new(@join_link)
      @svg = join_qr.as_svg(
        color: "000",
        shape_rendering: "crispEdges",
        module_size: 11,
        standalone: true,
        use_path: true
      )
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
      @quiz = Quiz.find_by!(code: session[:hosting])
    end
  end
end
