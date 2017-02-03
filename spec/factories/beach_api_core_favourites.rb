FactoryGirl.define do
  factory :beach_api_core_favourite, class: 'BeachApiCore::Favourite' do
    user
    # TODO: change to another favouritable entity
    favouritable { build :user }
  end
end
