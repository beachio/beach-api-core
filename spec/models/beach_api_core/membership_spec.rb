require 'rails_helper'

module BeachApiCore
  describe Membership, type: :model do
    subject { build(:membership) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should belong_to :member
      should belong_to :group
      should validate_uniqueness_of(:group_id).scoped_to(:group_type, :member_id, :member_type)
      should validate_presence_of :member
      should validate_presence_of :group
    end
  end
end
