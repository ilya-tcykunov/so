# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    body ""
    question ""
    user "MyString"
    reference "MyString"
  end
end
