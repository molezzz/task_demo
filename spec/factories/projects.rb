# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    key "MyString"
    title "MyString"
    team nil
  end
end
