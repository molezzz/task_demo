require 'rails_helper'

RSpec.describe Todo, :type => :model do
  describe "On Create" do

    it 'content can not be blank' do
      todo = Todo.new

      expect(todo.valid?).to eq(false)
      expect(todo.errors[:content]).to eq([I18n.t('errors.messages.blank')])

    end

  end
end
