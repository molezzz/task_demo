require 'rails_helper'

RSpec.describe Todo, :type => :model do

  describe "On Create" do

    it 'content can not be blank' do
      todo = Todo.new

      expect(todo.valid?).to eq(false)
      expect(todo.errors[:content]).to eq([I18n.t('errors.messages.blank')])

    end

  end

  describe "With Events" do

    it "should create a `todo.created` event on created" do
      todo = FactoryGirl.create(:todo_test)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo.created')
      expect(event.target_id).to eq(todo.id)
    end

    it "should have `source_id` when user create todo" do
      bill = FactoryGirl.create(:user_bill)
      todo = bill.created_todos.new(content: 'bill create')
      todo.save!

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo.created')
      expect(event.source_id).to eq(bill.id)
    end

    it "should create a `todo.destroyed` event on destroy" do
      todo = FactoryGirl.create(:todo_test)
      todo.destroy
      event = Event.where(target_id: todo.id)
                   .where(target: todo.class.name)
                   .last

      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo.destroyed')
    end

    it "should create a `todo.changed...` event on `content` change" do
      todo = FactoryGirl.create(:todo_test)
      todo.content = 'hello'
      todo.save!
      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo.changed.content.modify')
    end

    it "should create a `todo...finished` event but not a `todo...fix_complate` event on complate a todo" do

      todo = FactoryGirl.create(:todo_test)
      time = Time.zone.now
      expect {todo.complate}.to change{todo.complate_at.to_i}.to eq(time.to_i)

      #两条事件，一个是创建，一个是完成。不应该存在第三条
      expect(todo.events.count).to eq(2)
      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo.changed.complate_at.finished')

    end

    it "should create a `todo...fix_complate` event on change todo complate time" do

      todo = FactoryGirl.create(:todo_test)
      time1 = Time.zone.now
      time2 = time1 + 1.day

      todo.complate(time1)
      todo.complate(time2)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo.changed.complate_at.fix_complate')

    end

    it "should create a `todo...reopen` event on reopen a todo" do

      todo = FactoryGirl.create(:todo_test)
      todo.complate

      expect{todo.reopen}.to change{todo.complate_at}.to(nil)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo.changed.complate_at.reopen')

    end

    it "should create a `todo.changed...dispatch` event on dispatch a todo" do

      user = FactoryGirl.create(:user_bill)
      todo = FactoryGirl.create(:todo_test)
      expect{todo.dispatch_to(user)}.to change{todo.owner_id}.from(nil).to(user.id)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo.changed.owner_id.dispatch')
    end

    it "should create a `todo.change...redispatch` event on redispatch a todo" do

      bill = FactoryGirl.create(:user_bill)
      tom = FactoryGirl.create(:user_tom)
      todo = FactoryGirl.create(:todo_test)
      todo.dispatch_to(bill)
      expect{todo.dispatch_to(tom, true)}.to change{todo.owner_id}.from(bill.id).to(tom.id)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo.changed.owner_id.redispatch')
    end

    it "should create a `todo.change...revoke` event on revoke a todo" do
      bill = FactoryGirl.create(:user_bill)
      todo = FactoryGirl.create(:todo_test)
      todo.dispatch_to(bill)
      expect{todo.revoke}.to change{todo.owner_id}.from(bill.id).to(nil)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo.changed.owner_id.revoke')
    end

    it "should create a `todo.change...go` event on start a todo" do
      bill = FactoryGirl.create(:user_bill)
      todo = FactoryGirl.create(:todo_test)
      todo.dispatch_to(bill)
      expect{todo.go}.to change{todo.begin_at}.from(nil)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo.changed.begin_at.go')
    end

    it "should create a `todo.change...delete` event on delete a todo" do
      bill = FactoryGirl.create(:user_bill)
      todo = FactoryGirl.create(:todo_test)
      bill.will_change(todo) do |t|
        expect{todo.del}.to change{todo.delete_at}.from(nil)
      end
      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo.changed.delete_at.delete')
    end

    it "should create a `todo_asso...add` event on post a comment to a todo" do
      todo = FactoryGirl.create(:todo_test)
      todo.comments << FactoryGirl.build(:comment)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo_asso_comments_add')
    end

    it "should have a source when in `will_change` block" do
      bill = FactoryGirl.create(:user_bill)
      todo = FactoryGirl.create(:todo_test)

      bill.will_change(todo) do |todo|
        todo.dispatch_to(bill)
      end

      event = todo.events.last
      expect(event.source_id).to eq(bill.id)
    end

  end

end
