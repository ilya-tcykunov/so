module Votable
  extend ActiveSupport::Concerns

  def voting_of user
    votings.where(user: user).first
  end

  def common_opinion
    votings.common_opinion
  end

  def opinion_of user
    voting_of(user).opinion rescue 0
  end
end