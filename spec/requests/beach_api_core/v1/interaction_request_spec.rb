require 'rails_helper'

module BeachApiCore
  describe 'V1::Interaction', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    INTERACTION_KEYS = %i(id created_at kind template user interaction_attributes interaction_keepers).freeze

    describe 'when create' do
      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_interactions_path }
        end
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_interactions_path, headers: invalid_bearer_auth }
        end

        it 'should return bad request status if interaction is invalid' do
          interaction_params = { kind: Faker::Lorem.word }
          expect do
            post beach_api_core.v1_interactions_path, params: { interaction: interaction_params }, headers: bearer_auth
          end.not_to change(Interaction, :count)
          expect(response.status).to eq 400
          expect(json_body[:error]).to be_present
        end
      end

      context 'when valid' do
        let(:entity) { create :entity }
        let(:interaction_params) do
          { kind: Faker::Lorem.word,
            interaction_attributes_attributes: [key: "#{Faker::Lorem.word}-#{Faker::Number.number(2)}",
                                                values: { 'text' => Faker::Lorem.sentence }],
            interaction_keepers_attributes: [keeper_type: entity.class.to_s,
                                             keeper_id: entity.id] }
        end

        it 'should create new interaction with correct fields' do
          expect do
            post beach_api_core.v1_interactions_path, params: { interaction: interaction_params }, headers: bearer_auth
          end.to change(Interaction, :count).by(1)
          interaction = Interaction.last
          expect(interaction.kind).to eq interaction_params[:kind]
          expect(interaction.user_id).to eq oauth_user.id
          %i(key values).each do |key|
            expect(interaction.interaction_attributes.first.send(key))
              .to eq interaction_params[:interaction_attributes_attributes].first[key]
          end
          %i(keeper_type keeper_id).each do |key|
            expect(interaction.interaction_keepers.first.send(key))
              .to eq interaction_params[:interaction_keepers_attributes].first[key]
          end
        end

        it 'should return interaction' do
          post beach_api_core.v1_interactions_path, params: { interaction: interaction_params }, headers: bearer_auth
          interaction = Interaction.last
          expect(response.status).to eq 200
          expect(json_body[:interaction]).to be_present
          expect(json_body[:interaction].keys).to contain_exactly(*INTERACTION_KEYS)
          %i(id kind).each { |key| expect(json_body[:interaction][key]).to eq interaction.send(key) }
          expect(json_body[:interaction][:user][:id]).to eq oauth_user.id
        end
      end
    end
  end
end
