FactoryGirl.define do
  factory :user, class: 'BeachApiCore::User' do
    email { Faker::Internet.email }
    password { Faker::Internet.password(6) }
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
