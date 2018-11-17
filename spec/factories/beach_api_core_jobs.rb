FactoryBot.define do
  factory :job, class: 'BeachApiCore::Job' do
    start_at { Faker::Date.forward(5) }
    done { false }
    application { build :oauth_application }
    params do
      { headers: { 'Authorization' => "Bearer #{SecureRandom.hex}" },
        method: %w(GET POST PUT PATCH DELETE).sample,
        uri: 'http://www.example.com/uri',
        input: { "#{Faker::Lorem.word}": Faker::Lorem.word } }
    end
  end
end
