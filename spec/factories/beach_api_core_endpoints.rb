FactoryBot.define do
  factory :beach_api_core_endpoint, class: 'BeachApiCore::Endpoint' do
    type { "" }
    actions { "MyString" }
  end
end
