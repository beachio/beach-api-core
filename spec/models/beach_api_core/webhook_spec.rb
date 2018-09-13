require 'rails_helper'

module BeachApiCore
  RSpec.describe Webhook, type: :model do
    subject { build(:webhook) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :uri
      should validate_presence_of :kind
      should validate_presence_of :keeper
      should define_enum_for(:kind).with(organisation_created: 0, team_created: 1,
                                         user_created: 2, organisation_deleted: 3, :scores_achieved => 4)
    end
  end
end
