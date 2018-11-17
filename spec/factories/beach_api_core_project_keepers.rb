FactoryBot.define do
  factory :project_keeper, class: 'BeachApiCore::ProjectKeeper' do
    keeper { BeachApiCore::Instance.current }

    after(:build) do |project_keeper|
      project_keeper.project = build(:project, project_keepers: [project_keeper])
    end
  end
end
