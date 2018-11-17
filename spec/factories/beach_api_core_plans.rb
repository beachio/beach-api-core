FactoryBot.define do
  factory :plan, class: 'BeachApiCore::Plan' do
    name { Faker::Job.title }
  end
end
