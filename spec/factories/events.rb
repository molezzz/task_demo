# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    kind "MyString"
    source_id 1
    target "MyString"
    target_id 1
    data "MyText"
  end
end
