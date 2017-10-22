require 'rails_helper'

module BeachApiCore
  describe OrganisationPlan, type: :model do
    subject { build :organisation_plan }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have relations' do
      should belong_to :organisation
      should belong_to :plan
    end
  end
end
