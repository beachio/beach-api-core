
require 'rails_helper'

module BeachApiCore
  describe 'V1::User', type: :request do

    describe 'when create' do
      include_context 'signed up developer'
      include_context 'bearer token authentication'

      context 'when valid request' do
        it "has status 'created'" do
          create_user_request
          expect(response.status).to eq(201)
        end

        it 'creates users' do
          expect do
            create_user_request
            create_user_request email: Faker::Internet.email
          end.to change(User, :count).by(2)
                     .and change(ActionMailer::Base.deliveries, :count).by(2)
        end

        it_behaves_like 'valid user response' do
          before { create_user_request }
        end
      end

      context 'when invalid request' do
        let!(:existed_user) { create :user }
        [{ email: Faker::Internet.email },
         { password: Faker::Internet.password }].each do |params|
          it do
            create_user_request(email: nil, password: nil, params: params)
            expect(response.status).to eq(400)
            expect(json_body[:error][:message]).to_not be_nil
          end
        end
        it 'with existed user email' do
          create_user_request(email: existed_user.email, password: Faker::Internet.password)
          expect(response.status).to eq(400)
          expect(json_body[:error][:message]).to_not be_nil
        end
      end

      context 'with application credentials' do
        it 'creates a bearer token for authorized application' do
          expect { create_user_request(headers: application_auth) }
              .to change(Doorkeeper::AccessToken, :count).by(1)
              .and change(User, :count).by(1)
          expect(json_body[:access_token]).to be_present
        end

        it 'does not create a user and return an error if incorrect application credentials' do
          expect { create_user_request(headers: invalid_app_auth) }.to change(User, :count).by(0)
          expect(response.status).to eq(401)
        end
      end
    end

    describe 'when show' do
      include_context 'signed up developer'
      include_context 'authenticated user'
      include_context 'bearer token authentication'

      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_user_path }
      end
      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_user_path, headers: invalid_bearer_auth }
      end

      context 'when valid' do
        before do
          create :profile_custom_field
          create :profile_custom_field, name: :custom_instance_field, keeper: Instance.current
          create :profile_custom_field, name: :custom_application_field, keeper: oauth_application
          get beach_api_core.v1_user_path, headers: bearer_auth
        end
        it { expect(response.status).to eq(200) }
        it_behaves_like 'valid user response' do
          it do
            expect(json_body[:user][:profile].keys).to contain_exactly(:id, :first_name, :last_name,
                                                                       :birth_date, :sex, :time_zone, :avatar_url,
                                                                       :custom_instance_field, :custom_application_field)
          end
        end
        it 'returns organisations with roles' do
          organisation = create :organisation
          create :membership, member: oauth_user, group: organisation
          assignment = create :assignment, keeper: organisation, user: oauth_user, role: (create :role)
          get beach_api_core.v1_user_path, headers: bearer_auth
          expect(json_body[:user][:organisations]).to be_present
          expect(json_body[:user][:organisations].first[:current_user_roles]).to eq([assignment.role.name])
        end
      end
    end

    describe 'when update' do
      include_context 'signed up developer'
      include_context 'authenticated user'
      include_context 'bearer token authentication'

      it_behaves_like 'an authenticated resource' do
        before { patch beach_api_core.v1_user_path }
      end
      it_behaves_like 'an authenticated resource' do
        before { patch beach_api_core.v1_user_path, headers: invalid_bearer_auth }
      end

      context 'when valid' do
        context 'when success' do
          before do
            patch beach_api_core.v1_user_path, params: { user: { email: Faker::Internet.email,
                                                  username: Faker::Internet.user_name,
                                                  profile_attributes: { id: oauth_user.profile.id,
                                                                        first_name: Faker::Name.first_name,
                                                                        last_name: Faker::Name.last_name,
                                                                        sex: [:male, :female].sample
                                                  } } },
                  headers: bearer_auth
          end
          it { expect(response.status).to eq(200) }
          it_behaves_like 'valid user response'
        end

        context 'when success with custom fields' do
          let(:profile_custom_field1) { create :profile_custom_field, keeper: Instance.current }
          let(:profile_custom_field2) { create :profile_custom_field, keeper: oauth_application }
          let(:new_value1) { Faker::Lorem.word }
          let(:new_value2) { Faker::Lorem.word }
          before do
            patch beach_api_core.v1_user_path, params: { user: { profile_attributes: { id: oauth_user.profile.id,
                                                                        profile_custom_field1.name => new_value1,
                                                                        profile_custom_field2.name => new_value2
            } } },
                  headers: bearer_auth
          end
          it { expect(response.status).to eq(200) }
          it_behaves_like 'valid user response' do
            it do
              expect(json_body[:user][:profile][profile_custom_field1.name.to_sym]).to eq new_value1
              expect(json_body[:user][:profile][profile_custom_field2.name.to_sym]).to eq new_value2
            end
          end
        end

        context 'should skip not related attribute to keepers ' do
          let(:profile_custom_field) { create :profile_custom_field, keeper: create(:oauth_application) }
          before do
            patch beach_api_core.v1_user_path, params: { user: { profile_attributes: { id: oauth_user.profile.id,
                                                                        profile_custom_field.name => Faker::Lorem.word
            } } },
                  headers: bearer_auth
          end
          it { expect(json_body[:user][:profile][profile_custom_field.name.to_sym]).to be_blank }
        end

        it 'should update appropriate fields' do
          [{ params: { email: Faker::Internet.email }, key: :email },
           { params: { username: Faker::Internet.user_name }, key: :username }].each do |data|
            patch beach_api_core.v1_user_path, params: { user: data[:params] }, headers: bearer_auth
            expect(json_body[:user][data[:key]]).not_to eq oauth_user.send(data[:key])
          end
        end

        context 'with avatar' do
          let!(:simple_avatar) { fixture_file_upload('spec/uploads/test.png', 'image/png') }
          let(:base64_avatar) { "data:image/png;base64,#{Base64.encode64(File.read('spec/uploads/test.png'))}" }

          it 'should save the icon' do
            expect { patch beach_api_core.v1_user_path(oauth_user), params: { user: { profile_attributes: { id: oauth_user.profile.id,
                                                                                             avatar_attributes: { file: simple_avatar } } } },
                           headers: bearer_auth }.to change(Asset, :count).by(1)
            expect(oauth_user.profile.avatar).to be_present
          end

          it 'should save icon as base64' do
            expect { patch beach_api_core.v1_user_path(oauth_user), params: { user: { profile_attributes: { id: oauth_user.profile.id,
                                                                                             avatar_attributes: { base64: base64_avatar } } } },
                           headers: bearer_auth }.to change(Asset, :count).by(1)
            expect(oauth_user.profile.avatar).to be_present
          end

          context 'should remove existed' do
            let(:asset) { create(:asset) }
            before do
              oauth_user.profile.update_attributes(avatar: asset)
              patch beach_api_core.v1_user_path(oauth_user), params: { user: { profile_attributes: { id: oauth_user.profile.id,
                                                                                      avatar_attributes: { base64: base64_avatar } } } },
                    headers: bearer_auth
            end
            it { expect(Asset.find_by(id: asset.id)).to be_blank }
          end
        end
      end

    end
  end
end
