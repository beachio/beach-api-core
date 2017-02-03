require 'rails_helper'

module BeachApiCore
  describe Team, type: :model do
    subject { build(:team) }

    it 'should be valid with basic factory attributes' do
      expect(subject).to be_valid
    end

    it 'should have basic validations' do
      should validate_presence_of :name
      should validate_presence_of :application
      should belong_to :application
      should have_many :members
      should have_one :organisation
      should have_many :invitations
    end

    describe 'owners' do
      before do
        @team = create :team
        create :membership, group: @team
        @owner_membership = create :membership, group: @team, owner: true
        organisation = create :organisation
        create :membership, member: @team, group: organisation
        create :membership, group: organisation
        create :membership, group: @team
        @organisation_owner_membership = create :membership, owner: true, group: organisation
      end
      it 'should return team owners' do
        expect(@team.owners).to contain_exactly(@owner_membership.member, @organisation_owner_membership.member)
      end
    end
  end
end
