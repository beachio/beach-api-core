require 'rails_helper'

describe BeachApiCore::EntityPolicy do
  subject { described_class }
  let(:user) { create :user }
  let(:another_user) { create :user }
  let!(:entity) { create :entity, user: user }

  permissions :show? do
    it { is_expected.to permit(user, entity) }
    it { is_expected.to_not permit(another_user, entity) }
  end

  permissions :destroy? do
    it { is_expected.to permit(user, entity) }
    it { is_expected.to_not permit(another_user, entity) }
  end

  permissions :lookup? do
    it { is_expected.to permit(user, entity) }
    it { is_expected.to_not permit(another_user, entity) }
  end

  permissions :update? do
    it { is_expected.to permit(user, entity) }
    it { is_expected.to_not permit(another_user, entity) }
  end
end
