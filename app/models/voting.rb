class Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  scope :positive, -> { where(opinion: 'up') }
  scope :negative, -> { where(opinion: 'down') }
  scope :common_opinion, -> { sum(:opinion) }

  def up
    self.opinion = 1
  end

  def down
    self.opinion = -1
  end
end
