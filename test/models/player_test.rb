# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  buzzed_at  :datetime
#  locked_out :boolean          default(FALSE), not null
#  name       :string           not null
#  score      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quiz_id    :integer          not null
#
# Indexes
#
#  index_players_on_quiz_id  (quiz_id)
#
# Foreign Keys
#
#  quiz_id  (quiz_id => quizzes.id)
#
require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
