FactoryBot.define do
  factory :assignment, class: 'BeachApiCore::Assignment' do
    keeper { BeachApiCore::Instance.current }
    role
    user
  end
end
