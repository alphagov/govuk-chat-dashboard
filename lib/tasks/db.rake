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
end
