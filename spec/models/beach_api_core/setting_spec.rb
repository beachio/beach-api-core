require 'rails_helper'

module BeachApiCore
  RSpec.describe Setting, type: :model do
    subject { build(:setting) }

    it do
      should respond_to :key
      should respond_to :value

      should validate_presence_of :key
      should validate_presence_of :keeper
    end

    describe 'dynamic methods' do
      it 'should have method if key exists' do
        setting = create :setting, keeper: BeachApiCore::Instance.current
        expect(Setting.send(setting.key)).to eq setting.value
      end

      it "should return nil if key doesn't exist" do
        expect(Setting.send(Faker::Lorem.characters)).to be_nil
      end

      it "shouldn't be valid if key is not allowed" do
        setting = build :setting, key: 'name'
        expect(setting).not_to be_valid
      end
    end
  end
end
