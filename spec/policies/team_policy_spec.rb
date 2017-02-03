require 'rails_helper'

describe BeachApiCore::TeamPolicy do
  subject { described_class }

  let!(:team) { create :team }
  let!(:owner) { (create :membership, group: team, owner: true).member }
  let!(:user) { (create :membership, group: team).member }

  [:update?, :destroy?].each do |action|
    permissions action do
      it { is_expected.to permit(owner, team) }
      it { is_expected.to_not permit(user, team) }
    end
  end
end
