require 'rails_helper'

RSpec.describe Project, :type => :model do

  describe "On Create" do

    it 'title can not be blank' do
      project = Project.new

      expect(project.valid?).to eq(false)
      expect(project.errors[:title]).to eq([I18n.t('errors.messages.blank')])

    end
  end

end
