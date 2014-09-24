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

    it "should create a `todo_create` event on created" do
      todo = FactoryGirl.create(:todo)
      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo_create')
      expect(event.target_id).to eq(todo.id)
    end

    it "should create a `todo_destroy` event on destroy" do
      todo = FactoryGirl.create(:todo)
      todo.destroy
      event = Event.where(target_id: todo.id)
                   .where(target: todo.class.name)
                   .last

      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo_destroy')
    end

    it "should create a `todo_change...` event on `content` change" do
      todo = FactoryGirl.create(:todo)
      todo.content = 'hello'
      todo.save!
      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo_attr_content_changed')
    end

    it "should create a `todo_..._finished` event but not a `todo_...fix_complate` event on complate a todo" do

      todo = FactoryGirl.create(:todo)
      time = Time.zone.now
      expect {todo.complate}.to change{todo.complate_at.to_i}.to eq(time.to_i)

      #两条事件，一个是创建，一个是完成。不应该存在第三条
      expect(todo.events.count).to eq(2)
      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo_attr_complate_at_changed_finished')

    end

    it "should create a `todo_...fix_complate` event on change todo complate time" do

      todo = FactoryGirl.create(:todo)
      time1 = Time.zone.now
      time2 = time1 + 1.day

      todo.complate(time1)
      todo.complate(time2)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo_attr_complate_at_changed_fix_complate')

    end

    it "should create a `todo_change...dispatch` event on dispatch a todo" do

      user = FactoryGirl.create(:user_bill)
      todo = FactoryGirl.create(:todo)
      expect{todo.dispatch_to(user)}.to change{todo.owner_id}.from(nil).to(user.id)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo_attr_owner_id_changed_dispatch')
    end

    it "should create a `todo_change...redispatch` event on redispatch a todo" do

      bill = FactoryGirl.create(:user_bill)
      tom = FactoryGirl.create(:user_tom)
      todo = FactoryGirl.create(:todo)
      todo.dispatch_to(bill)
      expect{todo.dispatch_to(tom, true)}.to change{todo.owner_id}.from(bill.id).to(tom.id)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo_attr_owner_id_changed_redispatch')
    end

    it "should create a `todo_change...revoke` event on revoke a todo" do
      bill = FactoryGirl.create(:user_bill)
      todo = FactoryGirl.create(:todo)
      todo.dispatch_to(bill)
      expect{todo.revoke}.to change{todo.owner_id}.from(bill.id).to(nil)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo_attr_owner_id_changed_revoke')
    end

    it "should create a `todo_asso...add` event on post a comment to a todo" do
      todo = FactoryGirl.create(:todo)
      todo.comments << FactoryGirl.build(:comment)

      event = todo.events.last
      expect(event).to be_instance_of(Event)
      expect(event.kind).to eq('todo_asso_comments_add')
    end

    it "should have a source when in `will_change` block" do
      bill = FactoryGirl.create(:user_bill)
      todo = FactoryGirl.create(:todo)

      bill.will_change(todo) do |todo|        
        todo.dispatch_to(bill)
      end

      event = todo.events.last      
      expect(event.source_id).to eq(bill.id)
    end

  end

end
