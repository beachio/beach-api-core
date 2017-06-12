require 'rails_helper'

describe BeachApiCore::ChatPolicy do
  subject { described_class }
  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:application) { create :oauth_application, owner: another_user }
  let(:another_application) { create :oauth_application, owner: user }
  let!(:user_chat) { create :chat, :with_one_user, keeper: user }
  let!(:application_chat) { create :chat, keeper: application }

  permissions :add_recipient? do
    it { is_expected.to permit(UserContext.new(user, another_application), user_chat) }
    it { is_expected.to permit(UserContext.new(another_user, application), application_chat) }
    it { is_expected.to_not permit(UserContext.new(another_user, application), user_chat) }
    it { is_expected.to_not permit(UserContext.new(user, another_application), application_chat) }
  end

  permissions :read? do
    it { is_expected.to permit(UserContext.new(user_chat.users.first, another_application), user_chat) }
    it { is_expected.to_not permit(UserContext.new(another_user, another_application), user_chat) }
  end
end
