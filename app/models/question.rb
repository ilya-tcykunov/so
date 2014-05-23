class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable

  accepts_nested_attributes_for :attachments
  
  validates :title, :body, :user, presence: true
end
