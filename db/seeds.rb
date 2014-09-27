# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Team.delete_all
Project.delete_all
Todo.delete_all
Access.delete_all
Event.delete_all

team = FactoryGirl.create(:team)
project_wechat = FactoryGirl.create(:project_wechat)
project_web = FactoryGirl.create(:project_web)

users = {}
[:bill, :tom].each do |name|
  users[name] = FactoryGirl.create(:"user_#{name}", team: team)
  users[name].projects = [project_wechat, project_web]
end


todo_0 = FactoryGirl.create(:todo_0, project: project_wechat, creator: users[:bill])
todo_1 = FactoryGirl.create(:todo_1, project: project_wechat, creator: users[:tom])
todo_2 = FactoryGirl.create(:todo_2, project: project_web, creator: users[:bill])




#开始执行动作,生成event

users[:bill].will_change(todo_1) do |todo|

  todo.dispatch_to users[:tom]
  todo.dispatch_to users[:bill], true
  todo.go
  todo.comments << FactoryGirl.build(:comment, content: '开始干活了！')
  todo.complate
  todo.comments << FactoryGirl.build(:comment, content: '完成了，大家来看看效果！')

end

users[:tom].will_change(todo_2) do |todo|
  todo.dispatch_to users[:tom]
  todo.go
  todo.comments << FactoryGirl.build(:comment, content: '只加粗感觉不是很明显，试下加大字体，或者在颜色上区分下。')
end

users[:tom].will_change(todo_0) do |todo|
  todo.dispatch_to users[:bill]
  todo.comments << FactoryGirl.build(:comment, content: 'bill 这事还是你做比较合适')
end


users[:bill].will_change(todo_0) do |todo|
  todo.go
  todo.complate
  todo.comments << FactoryGirl.build(:comment, content: 'OK了，你看看行不行')
end


users[:tom].will_change(todo_0) do |todo|
  todo.comments << FactoryGirl.build(:comment, content: '好的，吃完回去试试')
  todo.reopen
  todo.comments << FactoryGirl.build(:comment, content: '感觉不是很好，要不你再改改')
end