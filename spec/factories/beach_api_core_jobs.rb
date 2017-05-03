FactoryGirl.define do
  factory :job, class: 'BeachApiCore::Job' do
    start_at { Faker::Date.forward(5) }
    done { false }
    params do
      { bearer: SecureRandom.hex,
        method: %w(GET POST PUT PATCH DELETE).sample,
        uri: 'http://www.example.com/uri',
        input: { "#{Faker::Lorem.word}": Faker::Lorem.word } }
    end
  end
end
