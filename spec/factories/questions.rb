# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    title "MyTitle"
    body "MyBody"
    user
  end

  factory :question_empty_title, class: 'Question' do
    title ''
    body ''
    user
  end
end
