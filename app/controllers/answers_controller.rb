class AnswersController < ApplicationController
  def index
    @header = params[:header]
    @value = params[:value]
    @answers = if @header == "was_answer_useful" # TODO: this is really bad and is now in multiple places - there should be a way to fix this using Feedback.level == "message"
                 [] # TODO: need to handle this - the approach below returns duplicate entries
               else
                 Answer.where(header: @header, value: @value)
               end
  end

  def show
    @answer = Answer.find(params[:id])
  end
end
