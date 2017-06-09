FactoryGirl.define do
  factory :message, class: 'BeachApiCore::Chat::Message' do
    sender { build :user }
    message { Faker::Lorem.sentence }

    trait :with_chat do
      after(:build) do |message|
        message.chat ||= build(:chat)
        if message.chat.chats_users.blank?
          message.chat.chats_users << build(:chats_user, chat: message.chat, user: message.sender)
        end
        if message.messages_users.blank?
          message.messages_users << build(:messages_user, message: message, user: message.sender)
        end
      end
    end
  end
end
