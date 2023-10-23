class FeedbacksController < ApplicationController
  def index
    render json: Feedback.all
  end
end
