FactoryGirl.define do
  factory :user, class: 'BeachApiCore::User' do
    email { Faker::Internet.email }
    password { Faker::Internet.password(6) }
  end

  factory :developer, parent: :user do
    after(:create) do |user|
      role = BeachApiCore::Role.find_by(name: :developer, keeper: BeachApiCore::Instance.current) ||
          create(:role, name: :developer, keeper: BeachApiCore::Instance.current)
      user.assignments.create(role: role)
    end
  end

  factory :admin, parent: :user do
    after(:create) do |user|
      role = BeachApiCore::Role.find_by(name: :admin, keeper: BeachApiCore::Instance.current) ||
          create(:role, name: :admin, keeper: BeachApiCore::Instance.current)
      user.assignments.create(role: role)
    end
  end

  factory :oauth_user, parent: :user do
  end
end
