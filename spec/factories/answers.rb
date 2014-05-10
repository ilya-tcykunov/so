# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    body "answer's body"
    question
    user
  end

  factory :answer_empty_body, class: 'Answer' do
    body ''
  end
end
