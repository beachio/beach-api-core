require 'rails_helper'

describe BeachApiCore::InstancePolicy do
  subject { described_class }

  before { BeachApiCore::Instance.instance_variable_set('@_current', nil) }

  let!(:instance) { create :instance }
  let!(:developer_role) { create :role, name: :developer, keeper: instance }
  let(:user) { create :user }
  let(:developer) { create :developer }
  let(:admin) { create :admin }

  permissions :developer? do
    it { is_expected.to permit(developer, instance) }
    it { is_expected.to_not permit(user, instance) }
  end

  permissions :admin? do
    it { is_expected.to permit(admin, instance) }
    it { is_expected.to_not permit(developer, instance) }
    it { is_expected.to_not permit(user, instance) }
  end

  permissions :developer_or_admin? do
    it { is_expected.to permit(developer, instance) }
    it { is_expected.to permit(admin, instance) }
    it { is_expected.to_not permit(user, instance) }
  end
end
