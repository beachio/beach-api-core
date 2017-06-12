require 'rails_helper'

module BeachApiCore
  describe 'V1::Chat::Message', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    MESSAGE_KEYS = %i(id message read sender).freeze

    describe 'when create' do
      let!(:chat) { create(:chat, :with_one_user, :with_oauth_user, oauth_user: oauth_user, keeper: oauth_user) }

      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_chat_messages_path(chat) }
        end
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_chat_messages_path(chat), headers: invalid_bearer_auth }
        end
      end

      context 'when valid' do
        let(:message_params) { { message: Faker::Lorem.sentence } }

        it 'should create new message with correct fields' do
          expect do
            post beach_api_core.v1_chat_messages_path(chat), params: { message: message_params }, headers: bearer_auth
          end.to change(Chat::Message, :count).by(1).and change(Chat::MessagesUser, :count)
          message = Chat::Message.last
          expect(message.sender).to eq oauth_user
          expect(message.message).to eq message_params[:message]
        end

        it 'should return message' do
          post beach_api_core.v1_chat_messages_path(chat), params: { message: message_params }, headers: bearer_auth
          message = Chat::Message.last
          expect(response.status).to eq 200
          expect(json_body[:message]).to be_present
          expect(json_body[:message].keys).to contain_exactly(*MESSAGE_KEYS)
          %i(id message).each { |field| expect(json_body[:message][field]).to eq message.send(field) }
          expect(json_body[:message][:read]).to eq message.read_by?(oauth_user)
          expect(json_body[:message][:sender][:id]).to eq oauth_user.id
        end
      end
    end

    describe 'when index' do
      context 'when invalid' do
        let(:chat) { create(:chat, :with_messages) }
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_chat_messages_path(chat) }
        end
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_chat_messages_path(chat), headers: invalid_bearer_auth }
        end
      end

      context 'when valid' do
        before do
          @chat = build(:chat, :with_one_user)
          @user = @chat.chats_users.first.user
          @chat.chats_users << build(:chats_user, user: oauth_user)
          @message = build(:message, sender: @user)
          @chat.messages << @message
          @chat.chats_users.map(&:user).each { |user| @message.messages_users.build(user: user) }
          @chat.save!
          create(:chat, :with_chats_users, :with_messages)
        end

        it 'should return chat messages' do
          get beach_api_core.v1_chat_messages_path(@chat), headers: bearer_auth
          expect(response.status).to eq 200
          expect(json_body[:messages]).to be_present
          expect(json_body[:messages].size).to eq 1
          expect(json_body[:messages].first.keys).to contain_exactly(*MESSAGE_KEYS)
          expect(json_body[:messages].first[:message]).to eq @message.message
          expect(json_body[:messages].first[:sender][:id]).to eq @user.id
        end
      end
    end
  end
end
