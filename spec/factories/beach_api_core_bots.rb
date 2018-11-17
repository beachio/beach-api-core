FactoryBot.define do
  factory :beach_api_core_bot, class: 'BeachApiCore::Bot' do
    application_id { 1 }
    name { "MyString" }
  end
end
