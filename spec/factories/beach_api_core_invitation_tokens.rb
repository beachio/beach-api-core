FactoryGirl.define do
  factory :invitation_token, class: 'BeachApiCore::InvitationToken' do
    user
    organisation
    entity { build(:user) }
  end
end
