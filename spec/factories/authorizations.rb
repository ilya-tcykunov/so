# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authorization do
    user
    provider "MyString"
    uid "MyString"
  end
end
