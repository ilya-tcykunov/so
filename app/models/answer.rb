class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable

  validates :body, :question, :user, presence: true
end
