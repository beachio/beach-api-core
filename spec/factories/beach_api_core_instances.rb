FactoryGirl.define do
  factory :beach_api_core_instance, class: 'BeachApiCore::Instance' do
    name { SecureRandom.uuid }
  end
end
