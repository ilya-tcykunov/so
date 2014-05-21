# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    body "My Comment"
    user
    association :commentable
  end

  factory :questions_comment, class: Comment do
    body "My Question's Comment"
    user
    association :commentable, factory: :question
  end

  factory :answers_comment, class: Comment do
    body "My Answer's Comment"
    user
    association :commentable, factory: :answer
  end
end
