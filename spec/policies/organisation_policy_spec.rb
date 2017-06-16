require 'rails_helper'

describe BeachApiCore::OrganisationPolicy do
  subject { described_class }

  let!(:organisation) { create :organisation }
  let!(:owner) { (create :membership, group: organisation, owner: true).member }
  let!(:user) { (create :membership, group: organisation).member }
  let!(:admin) { (create :membership, group: organisation).member }

  before do
    role = create :role, name: 'admin'
    create :assignment, role: role, keeper: organisation, user: admin
  end

  %i(update? destroy?).each do |action|
    permissions action do
      it { is_expected.to permit(owner, organisation) }
      it { is_expected.to permit(admin, organisation) }
      it { is_expected.to_not permit(user, organisation) }
    end
  end
end
