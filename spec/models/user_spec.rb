require 'rails_helper'

RSpec.describe User, :type => :model do

  describe "On Create" do

    it 'must have name and email attributes' do
      user = User.new

      expect(user.valid?).to eq(false)
      expect(user.errors[:name]).to eq([I18n.t('errors.messages.blank')])
      expect(user.errors[:email]).to eq([I18n.t('errors.messages.blank')])
    end

    it 'must have correct email attribute' do
      user = User.new(name: 'tom', email: 'wrong')

      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to eq([I18n.t('errors.messages.email')])
      expect(User.new(name: 'jerry', email: 'jerry@bdall.com').valid?).to eq(true)
    end

    it 'must have unique email' do
      bill = FactoryGirl.create(:user_bill)
      user = bill.dup

      expect(user.save).to eq(false)
      expect(user.errors[:email]).to eq([I18n.t('errors.messages.taken')])

    end

    it 'must have a correct avatar' do
      user = FactoryGirl.build(:user_bill)

      ok = %w{ zte.gif zte.jpg zte.png ZTE.JPG ZTE.Jpg
        http://jd.com/1/a/x/zte.gif }
      bad = %w{ zte.doc zte.gif/more zte.gif.more }

      ok.each do |name|
        user.avatar = name
        expect(user.valid?).to eq(true)
      end

      bad.each do |name|
        user.avatar = name
        expect(user.valid?).to eq(false)
        expect(user.errors[:avatar]).to eq([I18n.t('errors.messages.avatar')])
      end

    end

    it 'must have a key' do
      bill = FactoryGirl.create(:user_bill)

      expect(bill.key.length).to eq(40)
    end

  end

end
