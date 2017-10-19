FactoryGirl.define do
  factory :user_access, class: 'BeachApiCore::UserAccess' do
    keeper { BeachApiCore::Instance.current }
    access_level
    user
  end
end
