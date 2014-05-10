class Question < ActiveRecord::Base
  validates :title, :body, :user, presence: true

  belongs_to :user
  has_many :answers
end
