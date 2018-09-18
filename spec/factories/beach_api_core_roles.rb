FactoryGirl.define do
  factory :role, class: 'BeachApiCore::Role' do
    sequence(:name) { |n| "#{Faker::Lorem.word}_#{n}" }
  end

  factory :admin_role, parent: :role do
    name 'admin'
  end
end
