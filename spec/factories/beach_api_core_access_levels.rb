FactoryBot.define do
  factory :access_level, class: 'BeachApiCore::AccessLevel' do
    title { Faker::Lorem.word }
  end
end
