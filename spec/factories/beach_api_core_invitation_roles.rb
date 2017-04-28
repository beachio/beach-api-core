FactoryGirl.define do
  factory :invitation_role, class: 'BeachApiCore::InvitationRole' do
    invitation
    role
  end
end
