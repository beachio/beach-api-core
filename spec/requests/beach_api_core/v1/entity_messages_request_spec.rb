require 'rails_helper'

module BeachApiCore
  describe 'V1::EntityMessages', type: :request do
    include_context 'controller actions permissions'
    INTERACTION_USER_KEYS = %i(id email username first_name last_name avatar_url).freeze
    INTERACTION_KEEPER_KEYS = %i(id keeper_type keeper_id).freeze
    INTERACTION_ATTRIBUTE_KEYS = %i(id key values).freeze

    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    let(:message_text) { Faker::Lorem.sentence }
    let(:new_message_text) { Faker::Lorem.sentence }
    let(:entity) { create :entity, user: oauth_user }

    describe '#create' do
      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_entity_messages_path(entity) }
        end
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_entity_messages_path(entity), headers: invalid_bearer_auth }
        end
      end

      context 'when valid' do
        let(:message_params) { { text: message_text } }

        it 'should create interaction with correct fields' do
          expect do
            post beach_api_core.v1_entity_messages_path(entity),
                 params: { message: message_params },
                 headers: bearer_auth
          end.to change(BeachApiCore::Interaction, :count).by(1)

          interaction = BeachApiCore::Interaction.last

          expect(interaction.kind).to eq 'chat'
          expect(interaction.user).to eq oauth_user
          expect(interaction.interaction_keepers.size).to eq 1
          expect(interaction.interaction_keepers.first.keeper).to eq entity
          expect(interaction.interaction_attributes.size).to eq 1
          expect(interaction.interaction_attributes.first.key).to eq 'message'
          expect(interaction.interaction_attributes.first.values.keys).to eq ['text']
        end

        describe 'interaction response' do
          before do
            post beach_api_core.v1_entity_messages_path(entity),
                 params: { message: message_params },
                 headers: bearer_auth
            @interaction = BeachApiCore::Interaction.last
          end
          let(:interaction_body) { json_body[:interaction] }

          it_behaves_like 'successful response'
          it_behaves_like 'request: entity message response'
        end
      end
    end

    context 'with interaction' do
      before do
        @interaction = create(:interaction,
                              kind: 'chat',
                              user: oauth_user,
                              interaction_keepers: [build(:interaction_keeper, keeper: entity)],
                              interaction_attributes: [build(:interaction_attribute,
                                                             key: 'message', values: { text: message_text })])
      end

      describe '#index' do
        context 'when invalid' do
          it_behaves_like 'an authenticated resource' do
            before { get beach_api_core.v1_entity_messages_path(entity) }
          end
          it_behaves_like 'an authenticated resource' do
            before { get beach_api_core.v1_entity_messages_path(entity), headers: invalid_bearer_auth }
          end
        end

        context 'when valid' do
          describe 'interaction response' do
            before { get beach_api_core.v1_entity_messages_path(entity), headers: bearer_auth }
            let(:interaction_body) { json_body[:interactions].first }

            it_behaves_like 'successful response'
            it_behaves_like 'request: entity message response'

            it 'should return correct interaction array' do
              expect(json_body[:interactions].size).to eq 1
            end
          end
        end
      end

      describe '#update' do
        context 'when invalid' do
          it_behaves_like 'an authenticated resource' do
            before { put beach_api_core.v1_entity_message_path(entity, @interaction) }
          end
          it_behaves_like 'an authenticated resource' do
            before { put beach_api_core.v1_entity_message_path(entity, @interaction), headers: invalid_bearer_auth }
          end
        end

        context 'when valid' do
          let(:message_params) { { text: new_message_text } }

          it 'should update interaction attribute message' do
            expect do
              put beach_api_core.v1_entity_message_path(entity, @interaction),
                  params: { message: message_params },
                  headers: bearer_auth
            end.to(change { @interaction.reload.interaction_attributes.first.values })

            expect(@interaction.interaction_attributes.first.values['text']).to eq new_message_text
          end

          describe 'interaction response' do
            before do
              put beach_api_core.v1_entity_message_path(entity, @interaction),
                  params: { message: message_params },
                  headers: bearer_auth
              @interaction = BeachApiCore::Interaction.last
            end
            let(:interaction_body) { json_body[:interaction] }

            it_behaves_like 'successful response'
            it_behaves_like 'request: entity message response' do
              let(:message_text) { new_message_text }
            end
          end
        end
      end

      describe '#destroy' do
        context 'when invalid' do
          it_behaves_like 'an authenticated resource' do
            before { delete beach_api_core.v1_entity_message_path(entity, @interaction) }
          end
          it_behaves_like 'an authenticated resource' do
            before { delete beach_api_core.v1_entity_message_path(entity, @interaction), headers: invalid_bearer_auth }
          end
        end

        context 'when valid' do
          it 'should destroy interaction' do
            expect do
              delete beach_api_core.v1_entity_message_path(entity, @interaction), headers: bearer_auth
            end.to change(BeachApiCore::Interaction, :count).by(-1)

            expect(response.status).to eq 204
          end
        end
      end
    end
  end
end
