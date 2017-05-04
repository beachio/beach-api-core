FactoryGirl.define do
  factory :project, class: 'BeachApiCore::Project' do
    name { Faker::Lorem.word }
    user
    organisation

    after(:build) do |project|
      project.project_keepers << build(:project_keeper,
                                       project: project) if project.project_keepers.empty?
    end
  end
end
