# frozen_string_literal: true

class SpectatorsController < ApplicationController
  def show
    @quiz = Quiz.find_by!(code: params[:code].upcase)
    join_link = "http://#{`ipconfig getifaddr en0`.chomp}:3000/join/#{@quiz.code}"
    join_qr = RQRCode::QRCode.new(join_link)
    @join_qr_svg = join_qr.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 20,
      standalone: true,
      viewbox: true,
      use_path: true,
      svg_attributes: {
        class: "bg-white/90 border-2 p-4 rounded-lg"
      }
    )
  end
end
