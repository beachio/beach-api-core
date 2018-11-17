FactoryBot.define do
  factory :project, class: 'BeachApiCore::Project' do
    name { Faker::Lorem.word }
    user
    organisation

    after(:build) do |project|
      if project.project_keepers.empty?
        project.project_keepers << build(:project_keeper,
                                         project: project)
      end
    end
  end
end
