class FeedbacksController < ApplicationController
  skip_forgery_protection only: [:create]
  skip_before_action :authenticate_user!, only: [:create]

  def index
    @feedbacks = Feedback.all
  end

  def create
    feedback = Feedback.new(feedback_params)

    unless Feedback.all.map(&:id).include?(feedback.id)
      if feedback.save
        feedback.response.each do |key, value|
          Answer.create!(
            feedback_id: feedback.id,
            header: key,
            value: value,
            created_at: feedback.created_at,
            updated_at: feedback.updated_at,
          )
        end
      end
    end

    redirect_to feedback, status: :ok
  end

  private

  def feedback_params
    params.require(:feedback).permit(:chat_id, :uuid, :version, :level, :id, :created_at, :updated_at, response: {})
  end
end
