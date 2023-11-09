class HomeController < ApplicationController
  def index
    @total_chats = Chat.select("distinct uuid").count
    @conversation_feedback_count = Feedback.where(level: "conversation").count
    @percentage_conversation_feedback = calculate_percentage(@conversation_feedback_count, @total_chats)

    @total_questions = Chat.count
    @message_count = Feedback.where(level: "message").count
    @total_valid_replies = Chat.where.not("answer LIKE ?", "Sorry%").count

    @percentage_valid_replies = calculate_percentage(@total_valid_replies, @total_questions)
    @total_invalid_replies = Chat.where("answer LIKE ?", "Sorry%").count
    @percentage_invalid_replies = calculate_percentage(@total_invalid_replies, @total_questions)
  end

  private

  def calculate_percentage(x, y)
    percentage = ((x.to_f / y.to_f) * 100).round(2)

    "(#{percentage}%)"
  end
end
