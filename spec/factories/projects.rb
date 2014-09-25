# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project, class: Project do

    factory :project_wechat do
      title "Tower + 微信"
    end

    factory :project_web do
      title "TWR: 产品网站"
    end

  end
end
