FactoryGirl.define do
  factory :favourite, class: 'BeachApiCore::Favourite' do
    user
    favouritable { build :asset }
  end
end
