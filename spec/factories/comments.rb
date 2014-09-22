# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    key "MyString"
    user nil
    todo nil
    content "MyText"
  end
end
