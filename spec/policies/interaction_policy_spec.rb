require 'rails_helper'

describe BeachApiCore::InteractionPolicy do
  subject { described_class }
  let(:user) { create :user }
  let(:another_user) { create :user }
  let!(:interaction) { create :interaction, user: user }

  permissions :destroy? do
    it { is_expected.to permit(user, interaction) }
    it { is_expected.to_not permit(another_user, interaction) }
  end
end
