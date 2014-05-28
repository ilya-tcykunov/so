class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable, dependent: :destroy

  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :title, :body, :user, presence: true
end
