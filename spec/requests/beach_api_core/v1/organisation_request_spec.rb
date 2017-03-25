require 'rails_helper'

module BeachApiCore
  describe 'V1::Organisation', type: :request do

    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when create' do
      let!(:logo_image) { fixture_file_upload('spec/uploads/test.png', 'image/png') }

      context 'when valid' do
        before { post beach_api_core.v1_organisations_path,
                      params: { organisation: { name: Faker::Name.title, logo_image_attributes: { file: logo_image },
                                                logo_properties: { color: Faker::Lorem.word } } },
                      headers: bearer_auth }
        it { expect(response.status).to eq(201) }
        it_behaves_like 'valid organisation response' do
          it do
            expect(json_body[:organisation][:logo_properties]).to be_present
            expect(json_body[:organisation][:logo_url]).to be_present
          end
        end
      end

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_organisations_path, params: { organisation: { name: Faker::Name.title } } }
      end

      it 'should create an ownership record' do
        post beach_api_core.v1_organisations_path, params: { organisation: { name: Faker::Name.title } },
             headers: bearer_auth
        expect(oauth_user.organisations.first).to eq(Organisation.last)
        expect(Organisation.last.owners).to include(oauth_user)
      end
    end

    describe 'when update' do
      let(:owned_organisation) { (create :membership, member: oauth_user, owner: true,
                                         group: (create :organisation)).group }
      let(:organisation) { (create :membership, member: oauth_user, group: (create :organisation)).group }
      let(:new_name) { Faker::Name.title }

      context 'when valid' do
        before { patch beach_api_core.v1_organisation_path(owned_organisation), params: { organisation: { name: new_name } },
                       headers: bearer_auth }
        it { expect(owned_organisation.reload.name).to eq new_name }
        it_behaves_like 'valid organisation response'
      end

      it_behaves_like 'an forbidden resource' do
        before { patch beach_api_core.v1_organisation_path(organisation), params: { organisation: { name: new_name } },
                                                                  headers: bearer_auth }
      end

      it_behaves_like 'an authenticated resource' do
        before { patch beach_api_core.v1_organisation_path(owned_organisation), params: { organisation: { name: new_name } } }
      end

      it_behaves_like 'an authenticated resource' do
        before { patch beach_api_core.v1_organisation_path(owned_organisation), params: { organisation: { name: new_name } },
                                                                   headers: invalid_bearer_auth }
      end
    end

    describe 'when destroy' do
      let(:owned_organisation) { (create :membership, member: oauth_user,
                                                      group: (create :organisation), owner: true).group }
      let(:organisation) { (create :membership, member: oauth_user, group: (create :organisation)).group }

      it 'should allow owner to delete the organisation' do
        delete beach_api_core.v1_organisation_path(owned_organisation), headers: bearer_auth
        expect(response.status).to eq(200)
      end

      it_behaves_like 'an forbidden resource' do
        before { delete beach_api_core.v1_organisation_path(organisation), headers: bearer_auth }
      end
    end

    describe 'when show' do
      let(:owned_organisation) { (create :membership, member: oauth_user, owner: true,
                                         group: (create :organisation)).group }
      let(:organisation) { (create :membership, group: (create :organisation)).group }

      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_organisation_path(owned_organisation) }
      end
      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_organisation_path(owned_organisation), headers: invalid_bearer_auth }
      end
      it_behaves_like 'an forbidden resource' do
        before { get beach_api_core.v1_organisation_path(organisation), headers: bearer_auth }
      end

      context 'when valid' do
        before { get beach_api_core.v1_organisation_path(owned_organisation), headers: bearer_auth }
        it { expect(response.status).to eq(200) }
        it_behaves_like 'valid organisation response'
      end
    end

    describe 'when users' do
      let(:organisation) { (create :membership, member: oauth_user, group: (create :organisation)).group }

      before do
        2.times do |i|
          user = create :user, email: "test#{i}@i.com"
          create :membership, group: organisation, member: user
        end
        access_token.update(organisation: organisation)
      end

      it 'should return all available inventors for organisation' do
        get beach_api_core.users_v1_organisations_path, headers: bearer_auth
        expect(response.status).to eq 200
        expect(json_body[:users]).to be_present
        expect(json_body[:users].length).to eq 3
      end

      it 'should autocomplete available inventors for organisation' do
        request = -> (term) do
          get beach_api_core.users_v1_organisations_path, params: { term: term }, headers: bearer_auth
        end
        request.call('test')
        expect(response.status).to eq 200
        expect(json_body[:users]).to be_present
        expect(json_body[:users].length).to eq 2
        request.call('test1')
        expect(response.status).to eq 200
        expect(json_body[:users]).to be_present
        expect(json_body[:users].length).to eq 1
        request.call('fail')
        expect(response.status).to eq 200
        expect(json_body[:users].length).to eq 0
      end

    end
  end
end
