require 'spec_helper'

describe Voting do
  it 'calculates common opintion correctly' do
    question = create(:question)
    question.votings.create(attributes_for(:positive_voting, user: create(:user)))
    question.votings.create(attributes_for(:positive_voting, user: create(:user)))
    question.votings.create(attributes_for(:negative_voting, user: create(:user)))

    expect(question.votings.common_opinion).to eq 1
  end
end
