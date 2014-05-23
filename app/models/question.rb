class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable

  validates :title, :body, :user, presence: true
end
