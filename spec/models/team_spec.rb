require 'rails_helper'

RSpec.describe Team, :type => :model do

  describe "On Create" do

    it 'name can not be blank' do
      team = Team.new

      expect(team.valid?).to eq(false)
      expect(team.errors[:name]).to eq([I18n.t('errors.messages.blank')])

    end

  end

end
