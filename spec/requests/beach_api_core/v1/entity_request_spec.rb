require 'rails_helper'

module BeachApiCore
  describe 'V1::Entity', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    ENTITY_KEYS = %i(id user_id uid kind settings).freeze

    describe 'when create' do
      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_entities_path }
        end
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_entities_path, headers: invalid_bearer_auth }
        end

        it 'should return bad request status if entity is invalid' do
          entity_params = { kind: Faker::Lorem.word }
          expect do
            post beach_api_core.v1_entities_path, params: { entity: entity_params }, headers: bearer_auth
          end.not_to change(Entity, :count)
          expect(response.status).to eq 400
          expect(json_body[:error]).to be_present
        end
      end

      context 'when valid' do
        let(:entity_params) do
          { uid: Faker::Crypto.md5, kind: Faker::Lorem.word, settings: { key: Faker::Lorem.word } }
        end
        it 'should create new entity with correct fields' do
          expect do
            post beach_api_core.v1_entities_path, params: { entity: entity_params }, headers: bearer_auth
          end.to change(Entity, :count).by(1)
          entity = Entity.last
          (ENTITY_KEYS - %i(id user_id settings)).each { |key| expect(entity.send(key)).to eq entity_params[key] }
          expect(entity.user_id).to eq oauth_user.id
          expect(entity.settings.keys.size).to eq entity_params[:settings].keys.size
          entity.settings.each { |key, val| expect(val).to eq entity_params[:settings][key.to_sym] }
        end

        it 'should return entity' do
          post beach_api_core.v1_entities_path, params: { entity: entity_params }, headers: bearer_auth
          entity = Entity.last
          expect(response.status).to eq 200
          expect(json_body[:entity]).to be_present
          expect(json_body[:entity].keys).to contain_exactly(*ENTITY_KEYS)
          (ENTITY_KEYS - %i(settings)).each { |key| expect(json_body[:entity][key]).to eq entity.send(key) }
          expect(json_body[:entity][:settings].keys.size).to eq entity.settings.keys.size
          json_body[:entity][:settings].each { |key, val| expect(val).to eq entity.settings[key.to_s] }
        end
      end
    end

    describe 'when destroy' do
      context 'when invalid' do
        let(:entity) { create :entity }
        it_behaves_like 'an authenticated resource' do
          before { delete beach_api_core.v1_entity_path(entity) }
        end
        it_behaves_like 'an authenticated resource' do
          before { delete beach_api_core.v1_entity_path(entity), headers: invalid_bearer_auth }
        end

        context 'should not to be able remove not owned item' do
          it_behaves_like 'an forbidden resource' do
            before { delete beach_api_core.v1_entity_path(entity), headers: bearer_auth }
          end
        end
      end

      context 'when valid' do
        it 'should remove entity' do
          entity = create(:entity, user: oauth_user)
          delete beach_api_core.v1_entity_path(entity), headers: bearer_auth
          expect(response.status).to eq 204
          expect(Entity.find_by(id: entity.id)).to be_blank
        end
      end
    end

    describe 'when show' do
      context 'when invalid' do
        let(:entity) { create :entity }
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_entity_path(entity) }
        end
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_entity_path(entity), headers: invalid_bearer_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before { get beach_api_core.v1_entity_path(entity), headers: bearer_auth }
        end
      end

      context 'when valid' do
        it 'should show entity' do
          entity = create(:entity, user: oauth_user)
          get beach_api_core.v1_entity_path(entity), headers: bearer_auth
          expect(response.status).to eq 200
          expect(json_body[:entity]).to be_present
          expect(json_body[:entity].keys).to contain_exactly(*ENTITY_KEYS)
          (ENTITY_KEYS - %i(settings)).each { |key| expect(json_body[:entity][key]).to eq entity.send(key) }
          expect(json_body[:entity][:settings].keys.size).to eq entity.settings.keys.size
          json_body[:entity][:settings].each { |key, val| expect(val).to eq entity.settings[key.to_s] }
        end
      end
    end

    describe 'when lookup' do
      context 'when invalid' do
        let(:entity) { create :entity }
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.lookup_v1_entities_path(entity: { uid: entity.uid, kind: entity.kind }) }
        end
        it_behaves_like 'an authenticated resource' do
          before do
            get beach_api_core.lookup_v1_entities_path(entity: { uid: entity.uid, kind: entity.kind }),
                headers: invalid_bearer_auth
          end
        end
        it_behaves_like 'an forbidden resource' do
          before do
            get beach_api_core.lookup_v1_entities_path(entity: { uid: entity.uid, kind: entity.kind }),
                headers: bearer_auth
          end
        end
        context 'with authenticated user' do
          before { entity.update(user: oauth_user) }

          it 'should return bad request if uid is not provided' do
            expect do
              get beach_api_core.lookup_v1_entities_path(entity: { kind: entity.kind }), headers: bearer_auth
            end.to raise_error(ActionController::ParameterMissing)
          end

          it 'should return bad request if kind is not provided' do
            expect do
              get beach_api_core.lookup_v1_entities_path(entity: { uid: entity.uid }), headers: bearer_auth
            end.to raise_error(ActionController::ParameterMissing)
          end
        end
      end

      context 'when valid' do
        it 'should lookup entity by uid and kind' do
          entity = create(:entity, user: oauth_user)
          get beach_api_core.lookup_v1_entities_path(entity: { uid: entity.uid, kind: entity.kind }),
              headers: bearer_auth
          expect(response.status).to eq 200
          expect(json_body[:entity]).to be_present
          expect(json_body[:entity].keys).to contain_exactly(*ENTITY_KEYS)
          (ENTITY_KEYS - %i(settings)).each { |key| expect(json_body[:entity][key]).to eq entity.send(key) }
          expect(json_body[:entity][:settings].keys.size).to eq entity.settings.keys.size
          json_body[:entity][:settings].each { |key, val| expect(val).to eq entity.settings[key.to_s] }
        end
      end
    end
  end
end
