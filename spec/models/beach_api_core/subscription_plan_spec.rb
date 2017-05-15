require 'rails_helper'

module BeachApiCore
  RSpec.describe SubscriptionPlan, type: :model do
    subject { build :subscription_plan }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :amount
      should validate_presence_of :interval
      should validate_presence_of :stripe_id
      should validate_presence_of :name
    end
  end
end
