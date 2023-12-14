class ExploreController < ApplicationController
  def index
    charts = []
    labels = Answer.all.where.not(header: "any_other_comments").map(&:header).uniq
    labels.each do |label|
      data = Answer.all.where.not(value: nil).where(header: label).group(:value).count
      charts << ResultsOrderer.new({ label:, data: }).reorder
    end
    @charts = charts.to_json.html_safe
  end
end
