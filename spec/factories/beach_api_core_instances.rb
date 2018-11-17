FactoryBot.define do
  factory :instance, class: 'BeachApiCore::Instance' do
    name { SecureRandom.uuid }
  end
end
