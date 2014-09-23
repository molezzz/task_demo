require 'rails_helper'

RSpec.describe Comment, :type => :model do

  describe "On Create" do

    it "content can not be blank" do
      comment = Comment.new

      expect(comment.valid?).to eq(false)
      expect(comment.errors[:content]).to eq([I18n.t('errors.messages.blank')])

    end

  end

end
