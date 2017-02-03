FactoryGirl.define do
  factory :favourite, class: 'BeachApiCore::Favourite' do
    user
    # TODO: change to another favouritable entity
    favouritable { build :user }
  end
end
