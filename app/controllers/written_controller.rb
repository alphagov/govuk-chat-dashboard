class WrittenController < ApplicationController
  def index
    @answers = Answer.all.where.not(value: "").where(header: "any_other_comments")
  end
end
