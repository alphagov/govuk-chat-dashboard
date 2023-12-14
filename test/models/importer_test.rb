require "test_helper"
require "csv"
require "minitest/mock"

class ImporterTest < ActiveSupport::TestCase
  setup do
    @csv_content = CSV.read(
      Rails.root.join("test", "fixtures", "files", "answer_data.csv"),
      headers: true,
    )
    ENV["EXPORT_TO_CLOUD_STORAGE"] = "true"
  end

  test "import chats from GCP" do
    csv_content = CSV.read(
      Rails.root.join("test", "fixtures", "files", "answer_data.csv"),
      headers: true,
    )
    Importer.stub :read_from_gcp, csv_content do
      Importer.import
    end

    assert_equal 2, Chat.count
    assert_equal ["Artificial Intelligence", "Machine Learning"], Chat.pluck(:answer)
  end

  test "import feedback from gcp" do
    csv_content = CSV.read(
      Rails.root.join("test", "fixtures", "files", "answer_data.csv"),
      headers: true,
    )
    Importer.stub :read_from_gcp, csv_content do
      Importer.import
    end

    assert_equal 2, Feedback.count, "Expected 2 new Feedback records to be created"
    assert_equal 22, Answer.count, "Expected 22 new Answer records to be created"

    assert_equal ["No additional comments.", "Last written comment."],
                 Answer.where(header: "any_other_comments").pluck(:value)
  end
end
