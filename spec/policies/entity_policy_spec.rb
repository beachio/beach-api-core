require 'rails_helper'

describe BeachApiCore::EntityPolicy do
  subject { described_class }
  let(:user) { create :user }
  let(:another_user) { create :user }
  let!(:entity) { create :favourite, user: user }

  permissions :destroy? do
    it { is_expected.to permit(user, entity) }
    it { is_expected.to_not permit(another_user, entity) }
  end
end
