require 'rails_helper'

module BeachApiCore
  describe 'V1::Setting', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'
    include_context 'controller actions permissions'

    SETTING_KEYS = %i(id name value keeper_type keeper_id).freeze

    describe 'when update' do
      let(:owned_organisation) do
        (create :membership, member: oauth_user, group: (create :organisation), owner: true).group
      end

      it_behaves_like 'an authenticated resource' do
        before do
          put beach_api_core.v1_setting_path(Faker::Lorem.word),
              params: { setting: { value: Faker::Lorem.word },
                        group_type: 'Organisation',
                        group_id: owned_organisation.id }
        end
      end

      it 'should create new setting' do
        put beach_api_core.v1_setting_path('test_name'),
            params: { setting: { value: 'test_value' },
                      group_type: 'Organisation',
                      group_id: owned_organisation.id },
            headers: bearer_auth

        expect(response.status).to eq 200
        expect(json_body[:setting]).to be_present
        expect(json_body[:setting].keys).to contain_exactly(*SETTING_KEYS)
        setting = Setting.find_by(name: 'test_name')
        expect(setting).to be_present
        expect(setting.value).to eq('test_value')
        expect(setting.keeper).to eq(owned_organisation)
      end

      it 'should update existing setting' do
        setting = create :setting, keeper: owned_organisation
        new_value = Faker::Lorem.word
        put beach_api_core.v1_setting_path(setting.name),
            params: { setting: { value: new_value },
                      group_type: 'Organisation',
                      group_id: owned_organisation.id },
            headers: bearer_auth

        expect(response.status).to eq 200
        expect(json_body[:setting]).to be_present
        expect(json_body[:setting].keys).to contain_exactly(*SETTING_KEYS)
        expect(setting.reload.value).to eq(new_value)
      end
    end
  end
end
