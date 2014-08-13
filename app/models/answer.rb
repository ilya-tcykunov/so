class Answer < ActiveRecord::Base
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :comments, as: :commentable
  has_many :votings, as: :votable

  validates :body, :question, :user, presence: true
end
