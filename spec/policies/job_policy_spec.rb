require 'rails_helper'

describe BeachApiCore::JobPolicy do
  subject { described_class }
  let(:user) { create :user }
  let(:application) { create :oauth_application, owner: user }
  let(:another_application) { create :oauth_application, owner: user }
  let!(:job) { create :job, application: application }

  permissions :destroy? do
    it { is_expected.to permit(UserContext.new(user, application), job) }
    it { is_expected.to_not permit(UserContext.new(user, another_application), job) }
  end
end
