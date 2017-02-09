require 'rails_helper'

describe BeachApiCore::FavouritePolicy do
  subject { described_class }
  let(:user) { create :user }
  let(:another_user) { create :user }
  let!(:favourite) { create :favourite, user: user }

  permissions :destroy? do
    it { is_expected.to permit(user, favourite) }
    it { is_expected.to_not permit(another_user, favourite) }
  end
end
