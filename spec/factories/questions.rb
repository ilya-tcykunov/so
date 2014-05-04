# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    title "MyTitle"
    body "MyBody"
    user
  end
end
