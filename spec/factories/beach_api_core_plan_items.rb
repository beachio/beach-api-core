FactoryGirl.define do
  factory :plan_item, class: 'BeachApiCore::PlanItem' do
    plan
    access_level
    users_count { Faker::Number.number(2) }
  end
end
