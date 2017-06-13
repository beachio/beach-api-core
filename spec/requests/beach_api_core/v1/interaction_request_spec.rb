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

        context 'with template' do
          before { create(:template, name: interaction_params[:kind]) }

          it_behaves_like 'request: valid interaction create request', INTERACTION_KEYS

          it 'should return template' do
            post beach_api_core.v1_interactions_path, params: { interaction: interaction_params }, headers: bearer_auth
            interaction = BeachApiCore::Interaction.last
            expect(json_body[:interaction][:template][:value])
              .to eq interaction.templete.decorate.pretty_value(interaction)
          end
        end

        context 'without template' do
          it_behaves_like 'request: valid interaction create request', INTERACTION_KEYS
        end
      end
    end
  end
end
