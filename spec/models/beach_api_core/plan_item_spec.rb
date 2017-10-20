require 'rails_helper'

module BeachApiCore
  RSpec.describe PlanItem, type: :model do
    subject { build(:plan_item) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations and basic validations' do
      should belong_to :plan
      should belong_to :access_level
      should validate_presence_of :users_count
    end
  end
end
