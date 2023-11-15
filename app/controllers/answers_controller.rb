class AnswersController < ApplicationController

  def index
    @answers = Answer.where(header: "responses_were_useful", value: "Strongly agree")
  end

  def show
    @answer = Answer.find(params[:id])
  end
end
