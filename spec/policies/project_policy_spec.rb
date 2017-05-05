require 'rails_helper'

describe BeachApiCore::ProjectPolicy do
  subject { described_class }
  let!(:user) { create :user }
  let!(:another_user) { create :user }
  let!(:organisation) do
    (create :membership, member: user, group: (create :organisation)).group
  end
  let!(:project) { create :project, user: user, organisation: organisation }

  permissions :update? do
    it { is_expected.to permit(user, project) }
    it { is_expected.to_not permit(another_user, project) }
  end

  permissions :destroy? do
    it { is_expected.to permit(user, project) }
    it { is_expected.to_not permit(another_user, project) }
  end
end
