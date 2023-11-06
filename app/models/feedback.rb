class Feedback < ApplicationRecord
  belongs_to :chat, optional: true
  has_many :answers
end
