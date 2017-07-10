require 'rails_helper'

module BeachApiCore
  describe 'V1::Chat', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'
    include_context 'controller actions permissions'

    CHAT_KEYS = %i(id last_message users).freeze

    describe 'when create' do
      context 'without keeper' do
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_chats_path }
        end
      end

      context 'when user keeper' do
        context 'when invalid' do
          it_behaves_like 'an authenticated resource' do
            before { post beach_api_core.v1_chats_path, headers: invalid_bearer_auth }
          end
        end

        context 'when valid' do
          context 'without user in params' do
            it 'should create new chat with correct users' do
              expect { post beach_api_core.v1_chats_path, headers: bearer_auth }.to change(Chat, :count).by(1)
              chat = Chat.last
              expect(chat.user_ids).to eq [oauth_user.id]
              expect(chat.keeper).to eq oauth_user
            end

            it_behaves_like 'request: returns chat', CHAT_KEYS do
              before { post beach_api_core.v1_chats_path, headers: bearer_auth }
            end
          end

          context 'with users in params' do
            let(:other_user) { create(:user) }
            let(:chat_params) { { chats_users_attributes: [{ user_id: other_user.id }, { user_id: oauth_user.id }] } }

            it 'should create new chat with correct users' do
              expect do
                post beach_api_core.v1_chats_path, params: { chat: chat_params }, headers: bearer_auth
              end.to change(Chat, :count).by(1)
              chat = Chat.last
              expect(chat.users.count).to eq 2
              expect(chat.user_ids).to match_array [oauth_user.id, other_user.id]
              expect(chat.keeper).to eq oauth_user
            end

            it_behaves_like 'request: returns chat', CHAT_KEYS do
              before { post beach_api_core.v1_chats_path, params: { chat: chat_params }, headers: bearer_auth }
            end
          end
        end
      end

      context 'when application keeper' do
        context 'when invalid' do
          it_behaves_like 'an authenticated resource' do
            before { post beach_api_core.v1_chats_path, headers: invalid_app_auth }
          end
        end

        context 'when valid' do
          context 'without user in params' do
            it 'should create new chat with correct users' do
              expect do
                post beach_api_core.v1_chats_path, headers: application_auth
              end.to change(Chat, :count).by(1)
              chat = Chat.last
              expect(chat.user_ids).to be_empty
              expect(chat.keeper).to eq oauth_application
            end

            it_behaves_like 'request: returns chat', CHAT_KEYS do
              before { post beach_api_core.v1_chats_path, headers: application_auth }
            end
          end

          context 'with users in params' do
            let(:other_user) { create(:user) }
            let(:chat_params) { { chats_users_attributes: [{ user_id: other_user.id }] } }

            it 'should create new chat with correct users' do
              expect do
                post beach_api_core.v1_chats_path, params: { chat: chat_params }, headers: application_auth
              end.to change(Chat, :count).by(1)
              chat = Chat.last
              expect(chat.user_ids).to eq [other_user.id]
              expect(chat.keeper).to eq oauth_application
            end

            it_behaves_like 'request: returns chat', CHAT_KEYS do
              before { post beach_api_core.v1_chats_path, params: { chat: chat_params }, headers: application_auth }
            end
          end
        end
      end
    end

    describe 'when index' do
      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_chats_path }
        end
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_chats_path, headers: invalid_bearer_auth }
        end
      end

      context 'when valid' do
        before do
          create(:chat, :with_oauth_user, oauth_user: oauth_user)
          create(:chat, :with_chats_users)
        end
        it_behaves_like 'request: returns chats', CHAT_KEYS do
          before { get beach_api_core.v1_chats_path, headers: bearer_auth }
        end
      end
    end

    describe 'when add recipient' do
      context 'without keeper' do
        let(:chat) { create(:chat) }
        it_behaves_like 'an authenticated resource' do
          before { put beach_api_core.add_recipient_v1_chat_path(chat) }
        end
      end

      context 'with user keeper' do
        let!(:chat) { create(:chat, :with_oauth_user, oauth_user: oauth_user, keeper: oauth_user) }

        context 'when invalid' do
          it_behaves_like 'an authenticated resource' do
            before { put beach_api_core.add_recipient_v1_chat_path(chat) }
          end
          it_behaves_like 'an authenticated resource' do
            before { put beach_api_core.add_recipient_v1_chat_path(chat), headers: invalid_bearer_auth }
          end
        end

        context 'when valid' do
          let(:other_user) { create(:user) }
          let(:chat_params) { { recipient_id: other_user.id } }

          it 'should add recipient to existing chat' do
            expect do
              put beach_api_core.add_recipient_v1_chat_path(chat),
                  params: { chat: chat_params },
                  headers: bearer_auth
            end.to change(chat.users, :count).by(1)
            expect(chat.user_ids).to match_array([oauth_user.id, other_user.id])
          end

          it_behaves_like 'request: returns chat', CHAT_KEYS do
            before do
              put beach_api_core.add_recipient_v1_chat_path(chat),
                  params: { chat: chat_params },
                  headers: bearer_auth
            end
          end
        end
      end

      context 'with application keeper' do
        let!(:chat) { create(:chat, keeper: oauth_application) }

        context 'when invalid' do
          it_behaves_like 'an authenticated resource' do
            before { put beach_api_core.add_recipient_v1_chat_path(chat) }
          end
          it_behaves_like 'an authenticated resource' do
            before { put beach_api_core.add_recipient_v1_chat_path(chat), headers: invalid_app_auth }
          end
        end

        context 'when valid' do
          let(:other_user) { create(:user) }
          let(:chat_params) { { recipient_id: other_user.id } }

          it 'should add recipient to existing chat' do
            expect do
              put beach_api_core.add_recipient_v1_chat_path(chat),
                  params: { chat: chat_params },
                  headers: application_auth
            end.to change(chat.users, :count).by(1)
            expect(chat.user_ids).to match_array([other_user.id])
          end

          it_behaves_like 'request: returns chat', CHAT_KEYS do
            before do
              put beach_api_core.add_recipient_v1_chat_path(chat),
                  params: { chat: chat_params },
                  headers: application_auth
            end
          end
        end
      end
    end

    describe 'when read' do
      before do
        @chat = build(:chat, :with_one_user)
        @user = @chat.chats_users.first.user
        @chat.chats_users << build(:chats_user, user: oauth_user)
        @message = build(:message, sender: @user)
        @chat.messages << @message
        @chat.chats_users.map(&:user).each { |user| @message.messages_users.build(user: user) }
        @chat.save!
      end

      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { put beach_api_core. read_v1_chat_path(@chat) }
        end
        it_behaves_like 'an authenticated resource' do
          before { put beach_api_core. read_v1_chat_path(@chat), headers: invalid_bearer_auth }
        end
      end

      context 'when valid' do
        it 'should change read field' do
          expect do
            put beach_api_core.read_v1_chat_path(@chat), headers: bearer_auth
          end.to(change { @message.read_by?(oauth_user) })
        end

        it 'should return message' do
          put beach_api_core. read_v1_chat_path(@chat), headers: bearer_auth
          expect(response.status).to eq 200
          expect(json_body[:chat]).to be_present
          expect(json_body[:chat].keys).to contain_exactly(*CHAT_KEYS)
          expect(json_body[:chat][:id]).to eq @chat.id
          expect(json_body[:chat][:last_message][:id]).to eq @message.id
          expect(json_body[:chat][:last_message][:read]).to be_truthy
        end
      end
    end
  end
end
