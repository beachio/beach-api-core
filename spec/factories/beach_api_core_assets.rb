FactoryGirl.define do
  factory :asset, class: 'BeachApiCore::Asset' do
    entity { build :profile }
    file { Refile::FileDouble.new('dummy', 'logo.png', content_type: 'image/png') }
  end
end
