class AnswersController < ApplicationController

  def index
    @header = params[:header]
    @value = params[:value]
    if @header == 'was_answer_useful' # TODO: this is really bad and is now in multiple places - there should be a way to fix this using Feedback.level == "message"
      @answers = [] # TODO: need to handle this - the approach below returns duplicate entries
    else
      @answers = Answer.where(header: @header, value: @value)
    end
  end

  def show
    @answer = Answer.find(params[:id])
  end
end
