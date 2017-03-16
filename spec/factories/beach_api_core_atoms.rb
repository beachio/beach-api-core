FactoryGirl.define do
  factory :atom, class: 'BeachApiCore::Atom' do
    title { Faker::Name.title }
    kind { Faker::Lorem.word }

    trait :with_parent do
      atom_parent { build(:atom) }
    end
  end
end
