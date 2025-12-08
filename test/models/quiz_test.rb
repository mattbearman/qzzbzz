# == Schema Information
#
# Table name: quizzes
#
#  id                          :integer          not null, primary key
#  code                        :string           not null
#  current_question            :integer          default(0), not null
#  ended_at                    :datetime
#  name                        :string           not null
#  started_at                  :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  currently_calling_player_id :integer
#
# Indexes
#
#  index_quizzes_on_code                         (code) UNIQUE
#  index_quizzes_on_currently_calling_player_id  (currently_calling_player_id)
#
# Foreign Keys
#
#  currently_calling_player_id  (currently_calling_player_id => players.id)
#
require "test_helper"

class QuizTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
