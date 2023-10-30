class FeedbacksController < ApplicationController
  def index
    render json: Feedback.all
  end

  def create
    feedback = Feedback.new(feedback_params)

    if feedback.save
      render json: feedback, status: :created
    else
      render json: feedback.errors, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:chat_id, :uuid, :version, :level, :id, :created_at, :updated_at, response: {})
  end
end
