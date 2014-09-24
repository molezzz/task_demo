# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, :class => :User do

    factory :user_bill do
      team nil
      name "bill"
      email "bill@bdall.com"
      avatar "no.jpg"
    end

    factory :user_tom do
      team nil
      name "tom"
      email "tom@bdall.com"
      avatar "no_tom.jpg"
    end

  end
end
