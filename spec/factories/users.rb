# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, :class => :User do

    factory :user_bill do
      key "key"
      team nil
      name "bill"
      email "bill@bdall.com"
      avatar "no.jpg"
    end


  end
end
