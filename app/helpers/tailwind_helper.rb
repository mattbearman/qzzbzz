# frozen_string_literal: true

module TailwindHelper
  MAIN_BG_COLOR = "violet-950".freeze
  BUTTON_COLORS = {
    primary: "bg-emerald-500/80 hover:bg-emerald-500 text-white",
    danger: "bg-rose-500/80 hover:bg-rose-500 text-white"
  }.freeze

  BUTTON_SIZES = {
    md: "py-2 px-4 rounded-lg"
  }.freeze

  def button_classes(color: :primary, size: :md)
    "#{BUTTON_COLORS[color]} font-bold cursor-pointer #{BUTTON_SIZES[size]}"
  end

  def field_classes
    "flex flex-col sm:flex-row content-center sm:gap-6 pb-4"
  end

  def label_classes
    "py-1 border-y-2 border-#{MAIN_BG_COLOR}"
  end

  def input_classes
    "border-2 rounded-lg border-sky-500 bg-sky-500/20 px-2 py-1 w-full sm:w-auto"
  end

  def h1_classes
    "text-4xl mb-6 font-bold"
  end
end
