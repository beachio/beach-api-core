FactoryGirl.define do
  factory :permission, class: 'BeachApiCore::Permission' do
    atom
    keeper { build(:user) }
  end
end
