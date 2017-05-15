FactoryGirl.define do
  factory :subscription_plan, class: 'BeachApiCore::SubscriptionPlan' do
    name { Faker::Name.title }
    stripe_id { Faker::Lorem.word }
    amount { Faker::Number.between(1000, 10000) }
    interval { %w(year day month).sample }
  end
end
