require "test_helper"

class AnswerTest < ActiveSupport::TestCase
  setup do
    @answer = answers(:one)
  end

  %w[
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
  ].each do |header|
    test "allows #{header} header" do
      @answer.header = header
      assert @answer.valid?
    end
  end

  test "disallows other values for heaader" do
    @answer.header = "something else"
    assert_not @answer.valid?
  end

  %w[
    header
    value
    feedback
  ].each do |field|
    test "requires a value for #{field}" do
      @answer.send("#{field}=", nil)
      assert_not @answer.valid?
    end
  end
end
