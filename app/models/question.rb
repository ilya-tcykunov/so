class Question < ActiveRecord::Base
  include Votable

  belongs_to :user
  has_many :answers
  has_many :comments, as: :commentable
  has_many :votings, as: :votable
  has_many :attachments, as: :attachmentable, dependent: :destroy

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: lambda { |att| att[:file].blank? && att[:id].blank? }

  validates :title, :body, :user, presence: true
end
