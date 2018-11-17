FactoryBot.define do
  factory :entity, class: 'BeachApiCore::Entity' do
    user { create :user }
    uid { Faker::Crypto.md5 }
    kind { Faker::Lorem.word }
    settings { { key: Faker::Lorem.word } }
  end
end
