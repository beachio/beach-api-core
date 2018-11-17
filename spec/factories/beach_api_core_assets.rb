FactoryBot.define do
  factory :asset, class: 'BeachApiCore::Asset' do
    entity { build :profile }
    after(:build) do |asset|
      asset.file ||= Refile::FileDouble.new('dummy', 'logo.png', content_type: 'image/png')
    end
  end
end
