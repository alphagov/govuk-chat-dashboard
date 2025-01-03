namespace :db do
  desc "Imports data from Chats CSV file"
  task import_chat: :environment do
    Importer.import_chat
  end

  desc "Imports data from Feedback CSV file"
  task import_feedback: :environment do
    Importer.import_feedback
  end

  desc "Imports data from Chats and Feedback CSV files"
  task import: :environment do
    Importer.import
  end

  desc "Fake chat and feedback data"
  task fake_data: :environment do
    # We'll assume multiple questions per chat - each with message level
    # feedback, but only one conversation level feedback
    rand(10..15).times do
      uuid = SecureRandom.uuid

      rand(1..4).times do
        sources = []
        rand(1..5).times do
          sources << Faker::Internet.url(host: "gov.uk")
        end

        chat = Chat.create!(
          uuid:,
          prompt: Faker::Company.bs,
          answer: Faker::Lorem.paragraph(sentence_count: rand(1..4)),
          sources: sources.join(" | "),
        )

        message_feedback = Feedback.create!(
          chat_id: chat.id,
          uuid:,
          version: "v1",
          level: "message",
        )

        Answer.create!(
          feedback_id: message_feedback.id,
          header: "was_answer_useful",
          value: %w[Yes No].sample,
        )
      end

      feedback = Feedback.create!(
        uuid:,
        version: "v1",
        level: "conversation",
      )

      Answer.create!([
        {
          feedback_id: feedback.id,
          header: "responses_were_useful",
          value: ["Strongly agree", "Agree", "Undecided", "Disagree", "Strongly disagree"].sample,
        },
        {
          feedback_id: feedback.id,
          header: "experience_with_chat",
          value: ["Very satisfied", "Satisfied", "Neutral", "Dissatisfied", "Very dissatisfied"].sample,
        },
        {
          feedback_id: feedback.id,
          header: "trusted_the_answers",
          value: ["Strongly agree", "Agree", "Undecided", "Disagree", "Strongly disagree"].sample,
        },
        {
          feedback_id: feedback.id,
          header: "waiting_response_time",
          value: ["Quicker than expected", "Slower than expected", "About right", "I'm not sure"].sample,
        },
        {
          feedback_id: feedback.id,
          header: "inaccurate_or_inconsistent",
          value: ["Not at all concerned", "Slightly concerned", "Neutral", "Moderately concerned", "Extremely concerned"].sample,
        },
        {
          feedback_id: feedback.id,
          header: "did_you_know_answers",
          value: ["I knew answers to all the questions I asked", "I knew answers to some of the questions I asked", "I did not know any of the answers before using GOV.UK Chat"].sample,
        },
        {
          feedback_id: feedback.id,
          header: "best_describes_you",
          value: ["I'm thinking of starting a business", "I am a sole trader / self-employed", "I own a limited company", "I am in a partnership", "None of the above / other"].sample,
        },
        {
          feedback_id: feedback.id,
          header: "how_old_are_you",
          value: ["18 - 24", "25 - 34", "35 - 44", "45 - 54", "55 - 64", "65 - 74", "75+"].sample,
        },
        {
          feedback_id: feedback.id,
          header: "internet_skill_rating",
          value: ["I find all tasks easy online", "I find most tasks easy online", "Neutral", "I find some things difficult", "I often have difficulty using the internet"].sample,
        },
        {
          feedback_id: feedback.id,
          header: "any_other_comments",
          value: Faker::Lorem.paragraph(sentence_count: rand(0..4)),
        },
      ])
    end
  end
end
