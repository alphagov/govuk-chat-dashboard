class Answer < ApplicationRecord
  belongs_to :feedback

  VALID_HEADERS = %w[
    was_answer_useful
    responses_were_useful
    experience_with_chat
    trusted_the_answers
    waiting_response_time
    inaccurate_or_inconsistent
    did_you_know_answers
    best_describes_you
    how_old_are_you
    internet_skill_rating
    any_other_comments
  ].freeze
  private_constant :VALID_HEADERS

  validates :header, inclusion: VALID_HEADERS
  validates :value, presence: true
end
