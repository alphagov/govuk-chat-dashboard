class Chat < ApplicationRecord
  has_many :tags
  has_many :feedbacks
end
