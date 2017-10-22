require 'rails_helper'

module BeachApiCore
  RSpec.describe Plan, type: :model do
    subject { build(:plan) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations and basic validations' do
      should validate_presence_of :name
      should have_many :organisation_plans
      should have_many :plan_items
    end
  end
end
