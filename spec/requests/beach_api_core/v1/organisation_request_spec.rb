require 'rails_helper'

module BeachApiCore
  describe 'V1::Organisation', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when index' do
      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_organisations_path }
        end
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_organisations_path, headers: invalid_bearer_auth }
        end
      end

      context 'when valid' do
        it do
          create :membership, member: oauth_user, group: create(:organisation)
          create :organisation
          get beach_api_core.v1_organisations_path, headers: bearer_auth
          expect(response.status).to eq 200
          expect(json_body[:organisations]).to be_present
          expect(json_body[:organisations].size).to eq 1
          expect(json_body[:organisations].first.keys).to contain_exactly(*ORGANISATION_KEYS)
        end
      end
    end

    describe 'when create' do
      let!(:logo_image) { fixture_file_upload('spec/uploads/test.png', 'image/png') }

      context 'when valid' do
        before do
          @organisation_params = {
            organisation: { name: Faker::Job.title,
                            logo_image_attributes: { file: logo_image },
                            logo_properties: { color: Faker::Lorem.word } }
          }
        end
        context 'with create request' do
          before { post beach_api_core.v1_organisations_path, params: @organisation_params, headers: bearer_auth }
          it { expect(response.status).to eq 201 }
          it_behaves_like 'valid organisation response' do
            it do
              expect(json_body[:organisation][:logo_properties]).to be_present
              expect(json_body[:organisation][:logo_url]).to be_present
            end
          end
        end
        it 'should create webhooks notifier job' do
          expect do
            post beach_api_core.v1_organisations_path, params: @organisation_params, headers: bearer_auth
          end.to change(WebhooksNotifier.jobs, :count).by(1)
        end
      end

      it_behaves_like 'an authenticated resource' do
        before do
          post beach_api_core.v1_organisations_path,
               params: { organisation: { name: Faker::Job.title } }
        end
      end

      it 'should create an ownership record' do
        post beach_api_core.v1_organisations_path,
             params: { organisation: { name: Faker::Job.title } },
             headers: bearer_auth
        expect(oauth_user.organisations.first).to eq Organisation.last
        expect(Organisation.last.owners).to include(oauth_user)
      end

      it 'should create a notification record', current: true do
        expect(Notification.count).to eq(0)
        post beach_api_core.v1_organisations_path,
             params: { organisation: { name: Faker::Job.title } },
             headers: bearer_auth
        expect(Notification.count).to eq(1)
        notification = Notification.first
        expect(notification.message).to include("Organisation", "was created")
        expect(notification.user_id).to eq(oauth_user.id)
      end
    end

    describe 'when update' do
      let(:owned_organisation) do
        (create :membership, member: oauth_user, owner: true, group: (create :organisation)).group
      end
      let(:organisation) do
        (create :membership, member: oauth_user, group: (create :organisation)).group
      end
      let(:new_name) { Faker::Job.title }

      context 'when valid' do
        before do
          patch beach_api_core.v1_organisation_path(owned_organisation),
                params: { organisation: { name: new_name } },
                headers: bearer_auth
        end
        it { expect(owned_organisation.reload.name).to eq new_name }
        it_behaves_like 'valid organisation response'
      end

      it_behaves_like 'an forbidden resource' do
        before do
          patch beach_api_core.v1_organisation_path(organisation),
                params: { organisation: { name: new_name } },
                headers: bearer_auth
        end
      end

      it_behaves_like 'an authenticated resource' do
        before do
          patch beach_api_core.v1_organisation_path(owned_organisation),
                params: { organisation: { name: new_name } }
        end
      end

      it_behaves_like 'an authenticated resource' do
        before do
          patch beach_api_core.v1_organisation_path(owned_organisation),
                params: { organisation: { name: new_name } },
                headers: invalid_bearer_auth
        end
      end
    end

    describe 'when destroy' do
      let(:owned_organisation) do
        (create :membership, member: oauth_user, group: (create :organisation), owner: true).group
      end
      let(:organisation) do
        (create :membership, member: oauth_user, group: (create :organisation)).group
      end
      let(:organisation_to_notify) do
        (create :membership, member: oauth_user, group: (create :organisation), owner: true).group
      end

      it 'should allow owner to delete the organisation' do
        delete beach_api_core.v1_organisation_path(owned_organisation),
               headers: bearer_auth
        expect(response.status).to eq 204
      end

      it_behaves_like 'an forbidden resource' do
        before do
          delete beach_api_core.v1_organisation_path(organisation),
                 headers: bearer_auth
        end
      end

      it 'should create webhooks notifier job' do
        expect do
          delete beach_api_core.v1_organisation_path(organisation_to_notify),
                 headers: bearer_auth
        end.to change(WebhooksNotifier.jobs, :count).by(1)
      end
    end

    describe 'when show' do
      let(:owned_organisation) do
        (create :membership, member: oauth_user, owner: true, group: (create :organisation)).group
      end
      let(:organisation) { (create :membership, group: (create :organisation)).group }

      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_organisation_path(owned_organisation) }
      end
      it_behaves_like 'an authenticated resource' do
        before do
          get beach_api_core.v1_organisation_path(owned_organisation),
              headers: invalid_bearer_auth
        end
      end
      it_behaves_like 'an forbidden resource' do
        before do
          get beach_api_core.v1_organisation_path(organisation),
              headers: bearer_auth
        end
      end

      context 'when valid' do
        before do
          get beach_api_core.v1_organisation_path(owned_organisation),
              headers: bearer_auth
        end
        it { expect(response.status).to eq 200 }
        it_behaves_like 'valid organisation response'
      end
    end

    describe 'when users' do
      context 'when organisation member' do
        let!(:organisation) do
          (create :membership, member: oauth_user, group: (create :organisation)).group
        end

        before do
          access_token.update(organisation: organisation)
        end

        it 'should return list of users' do
          get beach_api_core.users_v1_organisations_path, headers: bearer_auth
          expect(response.status).to eq 200
          expect(json_body[:users]).to be_present
        end
      end

      context 'when organisation owner' do
        let!(:owned_organisation) do
          (create :membership, member: oauth_user, group: (create :organisation), owner: true).group
        end

        before do
          access_token.update(organisation: owned_organisation)
          2.times do
            user = (create :membership, group: owned_organisation).member
            create :assignment, user: user, keeper: owned_organisation
          end
        end

        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.users_v1_organisations_path }
        end

        it 'should return additional information for users' do
          get beach_api_core.users_v1_organisations_path, headers: bearer_auth
          expect(response.status).to eq 200
          expect(json_body[:users]).to be_present
          expect(json_body[:users].last).to include(:joined_at, :assignments, :profile)
          expect(json_body[:users].last[:assignments].first.keys).to include(:id, :role)
        end

        it 'should return users with provided roles' do
          role = create :role
          create :assignment, user: oauth_user, keeper: owned_organisation, role: BeachApiCore::Role.developer
          get beach_api_core.users_v1_organisations_path(roles: [role.id]), headers: bearer_auth
          expect(json_body[:users].size).to eq 3
          # get beach_api_core.users_v1_organisations_path(roles: [BeachApiCore::Role.developer.id]),
          #     headers: bearer_auth
          # expect(json_body[:users].size).to eq 1
        end
      end
    end

    describe 'when current' do
      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_organisations_path }
        end
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_organisations_path, headers: invalid_bearer_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before do
            organisation = create(:organisation)
            put beach_api_core.current_v1_organisation_path(organisation),
                headers: bearer_auth
          end
        end
      end

      it 'when valid' do
        organisation = create(:organisation)
        create :membership, member: oauth_user, group: organisation
        put beach_api_core.current_v1_organisation_path(organisation),
            headers: bearer_auth
        expect(response.status).to eq 200
        expect(access_token.reload.organisation).to eq organisation
      end
    end
  end
end
