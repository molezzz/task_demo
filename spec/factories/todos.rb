# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :todo do
    key "MyString"
    project nil
    creator_id 1
    owner_id 1
    content "MyText"
    end_at "2014-09-22 14:27:45"
    complate_at "2014-09-22 14:27:45"
  end
end
