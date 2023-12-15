class ResultsOrderer
  ORDERINGS = [
    {
      headers: %w[was_answer_useful],
      options: %w[Yes No],
    },
    {
      headers: %w[responses_were_useful trusted_the_answers],
      options: ["Strongly agree", "Agree", "Undecided", "Disagree", "Strongly disagree"],
    },
    {
      headers: %w[experience_with_chat],
      options: ["Very satisfied", "Satisfied", "Neutral", "Dissatisfied", "Very dissatisfied"],
    },
    {
      headers: %w[waiting_response_time],
      options: ["Quicker than expected", "Slower than expected", "About right", "I'm not sure"],
    },
    {
      headers: %w[inaccurate_or_inconsistent],
      options: ["Not at all concerned", "Slightly concerned", "Neutral", "Moderately concerned", "Extremely concerned"],
    },
    {
      headers: %w[did_you_know_answers],
      options: ["I knew answers to all the questions I asked", "I knew answers to some of the questions I asked", "I did not know any of the answers before using GOV.UK Chat"],
    },
    {
      headers: %w[best_describes_you],
      options: ["I'm thinking of starting a business", "I am a sole trader / self-employed", "I own a limited company", "I am in a partnership", "None of the above / other"],
    },
    {
      headers: %w[how_old_are_you],
      options: ["18 - 24", "25 - 34", "35 - 44", "45 - 54", "55 - 64", "65 - 74", "75+"],
    },
    {
      headers: %w[internet_skill_rating],
      options: ["I find all tasks easy online", "I find most tasks easy online", "Neutral", "I find some things difficult", "I often have difficulty using the internet"],
    },
  ].freeze
  private_constant :ORDERINGS

  attr_reader :label, :data

  def initialize(results)
    @label = results.fetch(:label)
    @data = results.fetch(:data)
  end

  def reorder
    reordered_data = {}
    ORDERINGS.each do |ordering|
      next unless ordering.fetch(:headers).include?(label)

      ordering.fetch(:options).each do |option|
        reordered_data[option] = data[option]
      end
    end
    { label:, data: reordered_data }
  end
end
