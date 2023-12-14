require "test_helper"
require "csv"
require "mocha/minitest"
require "google/cloud/storage"

class ImporterTest < ActiveSupport::TestCase
  setup do
    ENV["GCP_PROJECT_NAME"] = "the-proj"
    ENV["GCP_BUCKET_NAME"] = "the-bucket"
  end

  test "import chats from GCP" do
    csv_content = File.read(Rails.root.join("test", "fixtures", "files", "chat_data.csv"))
    stub_gcp_calls!("chat", csv_content)

    Importer.import_chat

    assert_equal 2, Chat.count
    assert_equal ["Artificial Intelligence", "Machine Learning"], Chat.pluck(:answer)
  end

  test "import feedback from gcp" do
    csv_content = File.read(Rails.root.join("test", "fixtures", "files", "answer_data.csv"))
    stub_gcp_calls!("feedback", csv_content)

    Importer.import_feedback

    assert_equal 2, Feedback.count, "Expected 2 new Feedback records to be created"
    assert_equal 22, Answer.count, "Expected 22 new Answer records to be created"
    assert_equal ["No additional comments.", "Last written comment."],
                 Answer.where(header: "any_other_comments").pluck(:value)
  end

  test ".import calls other import methods" do
    Importer.expects(:import_chat)
    Importer.expects(:import_feedback)
    Importer.import
  end

  def stub_gcp_calls!(data_set, csv_content)
    file_mock = mock("gcp_file", name: "#{data_set}-filename")
    file = mock("file", rewind: nil, read: csv_content)
    file_mock.stubs(:download).returns(file)
    bucket_mock = mock("bucket")
    files_mock = mock("files")
    files_mock.stubs(:max_by).returns(file_mock)
    bucket_mock.stubs(:files).with(prefix: data_set).returns(files_mock)
    storage_mock = mock("storage")
    storage_mock.stubs(:bucket).with("the-bucket").returns(bucket_mock)
    Google::Cloud::Storage.stubs(:new).with(project: "the-proj").returns(storage_mock)
  end
end
