require 'rails_helper'

RSpec.describe BeachApiCore::OrganisationPolicy do
  subject { described_class }

  let!(:organisation) { create :organisation }
  let!(:owner) { (create :membership, group: organisation, owner: true).member }
  let!(:user) { (create :membership, group: organisation).member }

  [:update?, :destroy?].each do |action|
    permissions action do
      it { is_expected.to permit(owner, organisation) }
      it { is_expected.to_not permit(user, organisation) }
    end
  end
end
