# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :voting do
    user
    association :votable

    factory :positive_voting, class: Voting do
      opinion 1
    end

    factory :negative_voting, class: Voting do
      opinion -1
    end
  end

  # factory :question_voting, class: Voting do
  #   user
  #   association :votable, factory: :question
  # end
end