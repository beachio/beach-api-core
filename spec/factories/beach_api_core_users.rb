FactoryBot.define do
  factory :user, class: 'BeachApiCore::User' do
    sequence(:email) { |n| Faker::Internet.email(name: Faker::Internet.user_name }
    password { Faker::Internet.password(min_length: 6) }
    confirmed_at { Time.now }

    after(:build) do |user|
      user.profile ||= build(:profile, user: user)
    end

    trait :with_organisation do
      after(:build) do |user|
        user.organisation_memberships.build(group: (create :organisation))
      end
    end
  end

  factory :developer, parent: :user do
    after(:create) do |user|
      role = BeachApiCore::Role.find_by(name: :developer) || create(:role, name: :developer)
      user.assignments.create(role: role, keeper: BeachApiCore::Instance.current)
    end
  end

  factory :admin, parent: :user do
    after(:create) do |user|
      role = BeachApiCore::Role.find_by(name: :admin) || create(:role, name: :admin)
      user.assignments.create(role: role, keeper: BeachApiCore::Instance.current)
    end
  end

  factory :oauth_user, parent: :user do
  end
end
