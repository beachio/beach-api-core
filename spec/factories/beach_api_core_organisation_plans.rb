FactoryBot.define do
  factory :organisation_plan, class: 'BeachApiCore::OrganisationPlan' do
    organisation
    plan
  end
end
