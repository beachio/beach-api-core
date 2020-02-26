FactoryBot.define do
  factory :plan, class: 'BeachApiCore::Plan' do
    name { Faker::Job.title }
    stripe_id {Faker::Job.field}
    amount {4500}
    interval {'year'}
    plan_for {'user'}
    currency {'usd'}
  end
end
