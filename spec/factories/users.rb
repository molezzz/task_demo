# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, :class => :User do

    factory :user_bill do
      name "bill"
      email "bill@bdall.com"
      avatar "no.jpg"
    end

    factory :user_tom do
      name "tom"
      email "tom@bdall.com"
      avatar "tom.jpg"
    end

  end
end
