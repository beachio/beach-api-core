FactoryBot.define do
  factory :atom, class: 'BeachApiCore::Atom' do
    title { Faker::Job.title }
    kind { Faker::Lorem.word }

    trait :with_parent do
      atom_parent { build(:atom) }
    end
  end
end
