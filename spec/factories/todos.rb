# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :todo, class: Todo do

    factory :todo_test do
      project nil
      creator_id 1
      owner_id nil
      content "todo test"
      end_at "2014-09-22 14:27:45"
      complate_at nil
    end

    %w{
      触屏版增加周报的view
      web和app上创建讨论在加锁的时候应该在通知人列表隐藏访客
      根据改版内容提纲，尝试设计Tower产品首页
    }.each_with_index do |s, i|
      factory :"todo_#{i}" do
        content s
        end_at  Time.now + 90.days
      end
    end

  end
end
