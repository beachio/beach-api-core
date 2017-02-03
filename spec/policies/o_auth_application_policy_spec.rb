require 'rails_helper'

RSpec.describe BeachApiCore::OAuthApplicationPolicy do
  subject { described_class }

  let(:user) { create :user }
  let(:owner) { create :user }
  let(:application) { create :oauth_application, owner: owner }
  let(:developer) { create :developer }
  let(:admin) { create :admin }

  permissions :show? do
    it { is_expected.to permit(owner, application) }
    it { is_expected.to_not permit(user, application) }
  end

  permissions :edit? do
    it { is_expected.to permit(owner, application) }
    it { is_expected.to_not permit(user, application) }
  end

  permissions :destroy? do
    it { is_expected.to permit(owner, application) }
    it { is_expected.to_not permit(user, application) }
  end

  permissions :manage? do
    it { is_expected.to permit(owner, application) }
    it { is_expected.to permit(admin, application) }
    it { is_expected.to permit(developer, application) }
    it { is_expected.to_not permit(user, application) }
  end
end
