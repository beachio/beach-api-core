FactoryGirl.define do
  factory :chat, class: 'BeachApiCore::Chat' do
    keeper { build(:user) }

    trait :with_one_user do
      after(:build) do |chat|
        chat.chats_users << build(:chats_user, chat: chat) if chat.chats_users.blank?
      end
    end

    trait :with_chats_users do
      after(:build) do |chat|
        2.times { chat.chats_users << build(:chats_user, chat: chat) } if chat.chats_users.blank?
      end
    end

    trait :with_messages do
      after(:build) do |chat|
        2.times { chat.chats_users << build(:chats_user, chat: chat) } if chat.chats_users.blank?
        if chat.messages.blank?
          message = build(:message, sender: chat.chats_users.first.user)
          chat.messages << message
          chat.chats_users.map(&:user).each { |user| message.messages_users.build(user: user) }
        end
      end
    end
  end
end
