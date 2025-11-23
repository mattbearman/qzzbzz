# frozen_string_literal: true

module TailwindHelper
  MAIN_BG_COLOUR = "bg-violet-950".freeze
  BUTTON_COLOURS = {
    filled: {
      grey: "border-2 border-slate-300 bg-slate-300 hover:bg-slate-200 text-slate-800",
      green: "border-2 border-emerald-600 bg-emerald-600 hover:bg-emerald-500 text-white",
      blue: "border-2 border-sky-500 bg-sky-500 hover:bg-sky-400 text-white",
      red: "border-2 border-rose-600 bg-rose-600 hover:bg-rose-500 text-white"
    },
    outline: {
      grey: "border-2 border-slate-300 text-slate-200 hover:bg-slate-300/10",
      green: "border-2 border-emerald-500 text-emerald-500 hover:bg-emerald-500/10",
      blue: "border-2 border-sky-500 text-sky-500 hover:bg-sky-500/10",
      red: "border-2 border-rose-400 text-rose-400 hover:bg-rose-400/10"
    }
  }.freeze

  BUTTON_SIZES = {
    md: "py-2 px-4 rounded-lg",
    lg: "py-4 px-6 rounded-lg text-xl",
    xl: "py-10 px-14 rounded-xl text-3xl sm:text-4xl"
  }.freeze

  def button_classes(colour: :green, size: :lg, style: :filled)
    "#{BUTTON_COLOURS[style][colour]} font-bold cursor-pointer inline-block #{BUTTON_SIZES[size]}"
  end

  def centered_classes
    "flex flex-col gap-4 md:gap-6 items-center justify-center h-full w-full max-w-md mx-auto"
  end

  def field_classes
    "flex flex-col content-center pb-4 w-full gap-2"
  end

  def label_classes
    "text-xl"
  end

  def input_classes
    "block text-xl border-2 rounded-lg border-sky-500 bg-sky-500/20 px-4 py-4 w-full"
  end

  def button_row_classes
    "flex flex-row justify-between gap-4 w-full"
  end

  def h1_classes
    "text-4xl mb-6 font-extrabold"
  end

  def h2_classes
    "text-2xl mb-4 font-bold"
  end
end
