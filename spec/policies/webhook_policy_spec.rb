require 'rails_helper'

describe BeachApiCore::WebhookPolicy do
  subject { described_class }
  let(:user) { create :user }
  let(:application) { create :oauth_application, owner: user }
  let(:another_application) { create :oauth_application, owner: user }
  let!(:webhook) { create :webhook, application: application }

  permissions :destroy? do
    it { is_expected.to permit(UserContext.new(user, application), webhook) }
    it { is_expected.to_not permit(UserContext.new(user, another_application), webhook) }
  end
end
