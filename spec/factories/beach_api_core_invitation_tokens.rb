FactoryGirl.define do
  factory :invitation_token, class: 'BeachApiCore::InvitationToken' do
    user
    entity { build(:user) }
  end
end
