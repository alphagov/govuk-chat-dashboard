require "csv"
require "google/cloud/storage"

class Importer
  def self.import_chat
    ActiveRecord::Base.transaction do
      Chat.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!("chats")

      csv_data = read_file("chat")
      csv_data.each do |row|
        Chat.create!(
          id: row["id"],
          uuid: row["uuid"],
          prompt: row["prompt"],
          answer: row["answer"],
          sources: row["sources"],
          created_at: row["created_at"],
          updated_at: row["updated_at"],
        )
      end
    end
  end

  def self.import_feedback
    ActiveRecord::Base.transaction do
      Answer.delete_all
      Feedback.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!("answers")
      ActiveRecord::Base.connection.reset_pk_sequence!("feedbacks")

      csv_data = read_file("feedback")
      csv_data.each do |row|
        feedback = Feedback.create!(
          id: row["id"],
          chat_id: row["chat_id"],
          uuid: row["uuid"],
          version: row["version"],
          level: row["level"],
          created_at: row["created_at"],
          updated_at: row["updated_at"],
        )

        %w[was_answer_useful responses_were_useful experience_with_chat trusted_the_answers waiting_response_time inaccurate_or_inconsistent did_you_know_answers best_describes_you how_old_are_you internet_skill_rating any_other_comments].each do |header|
          Answer.create!(
            feedback_id: feedback.id,
            header:,
            value: row[header],
          )
        end
      end
    end
  end

  def self.import
    import_chat
    import_feedback
  end

  def self.read_file(data_set)
    if ENV["EXPORT_TO_CLOUD_STORAGE"] == "true"
      read_from_gcp(data_set)
    else
      read_locally(data_set)
    end
  end

  def self.read_locally(data_set)
    filename = Dir.glob("imports/#{data_set}-*.csv").max_by { |f| File.mtime(f) }
    puts "Importing [#{filename}] from local storage"
    CSV.parse(File.read(filename), headers: true)
  end

  def self.read_from_gcp(data_set)
    storage = Google::Cloud::Storage.new project: ENV["GCP_PROJECT_NAME"]
    bucket = storage.bucket(ENV["GCP_BUCKET_NAME"])
    file = bucket.files(prefix: data_set).max_by(&:created_at)
    puts "Importing [#{file.name}] from GCP"
    download_file = file.download
    download_file.rewind
    CSV.parse(download_file.read, headers: true)
  end
end
