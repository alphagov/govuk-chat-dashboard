require "test_helper"
require "csv"
require "mocha/minitest"
require "google/cloud/storage"
require "fileutils"

class ImporterTest < ActiveSupport::TestCase
  setup do
    ENV["GCP_PROJECT_NAME"] = "the-proj"
    ENV["GCP_BUCKET_NAME"] = "the-bucket"
    ENV["EXPORT_TO_CLOUD_STORAGE"] = "true"
  end

  test "import chats from GCP" do
    csv_content = File.read(fixture_file_path("chat-data.csv"))
    stub_gcp_calls!("chat", csv_content)

    Importer.import_chat

    assert_equal 2, Chat.count
    assert_equal ["Artificial Intelligence", "Machine Learning"], Chat.pluck(:answer)
  end

  test "import chats from local file" do
    ENV["EXPORT_TO_CLOUD_STORAGE"] = nil
    prepare_local_file("chat-data.csv")

    begin
      Importer.import_chat

      assert_equal 2, Chat.count
      assert_equal ["Artificial Intelligence", "Machine Learning"], Chat.pluck(:answer)
    ensure
      delete_local_file("chat_data.csv")
    end
  end

  test "import feedback from gcp" do
    csv_content = File.read(fixture_file_path("feedback-data.csv"))
    stub_gcp_calls!("feedback", csv_content)

    Importer.import_feedback

    assert_equal 2, Feedback.count, "Expected 2 new Feedback records to be created"
    assert_equal 22, Answer.count, "Expected 22 new Answer records to be created"
    assert_equal ["No additional comments.", "Last written comment."],
                 Answer.where(header: "any_other_comments").pluck(:value)
  end

  test "import feedback from local file" do
    ENV["EXPORT_TO_CLOUD_STORAGE"] = nil
    prepare_local_file("feedback-data.csv")
    begin
      Importer.import_feedback

      assert_equal 2, Feedback.count, "Expected 2 new Feedback records to be created"
      assert_equal 22, Answer.count, "Expected 22 new Answer records to be created"
      assert_equal ["No additional comments.", "Last written comment."],
                   Answer.where(header: "any_other_comments").pluck(:value)
    ensure
      delete_local_file("answer-data.csv")
    end
  end

  test ".import calls other import methods" do
    Importer.expects(:import_chat)
    Importer.expects(:import_feedback)
    Importer.import
  end

private

  def prepare_local_file(filename)
    FileUtils.mkdir_p("imports/") unless Dir.exist?("imports/")
    FileUtils.cp(fixture_file_path(filename), local_file_path(filename))
  end

  def delete_local_file(filename)
    file_path = local_file_path(filename)
    File.delete(file_path) if File.exist?(file_path)
  end

  def local_file_path(filename)
    "imports/#{filename}"
  end

  def fixture_file_path(filename)
    Rails.root.join("test", "fixtures", "files", filename.to_s)
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
