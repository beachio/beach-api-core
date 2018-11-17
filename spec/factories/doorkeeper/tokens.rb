FactoryBot.define do
  factory :oauth_token, class: 'Doorkeeper::AccessToken' do
    resource_owner_id { :oauth_user_id }
    token { SecureRandom.hex }
  end
end
