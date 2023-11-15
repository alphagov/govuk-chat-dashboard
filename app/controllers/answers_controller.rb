class AnswersController < ApplicationController

  def index
    @header = params[:header]
    @value = params[:value]
    @answers = Answer.where(header: @header, value: @value)
  end

  def show
    @answer = Answer.find(params[:id])
  end
end
