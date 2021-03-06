FactoryBot.define do
  factory :oauth_application, class: '::Doorkeeper::Application' do
    name          { Faker::Company.name }
    redirect_uri  { Faker::Internet.redirect_uri }
    owner         { build :user }
    uid           { SecureRandom.hex }
    secret        { SecureRandom.hex }
  end
end
