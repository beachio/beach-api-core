require 'rails_helper'

module BeachApiCore
  describe JobRunner do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'should send a request with params from given job' do
      before do
        @job = create :job,
                      start_at: 2.days.since,
                      params: {
                        headers: { 'Authorization' => "Bearer #{access_token.token}" },
                        method: 'GET',
                        uri: 'http://www.example.com/v1/user'
                      }
      end

      it_behaves_like 'request: job succeeded'

      it_behaves_like 'request: job did not succeed'

      it_behaves_like 'request: job request result has an empty body'
    end

    describe 'should send request with replaced authentication header' do
      context 'with organisation' do
        let(:organisation) { create :organisation }
        let(:access_token) do
          Doorkeeper::AccessToken.create!(application_id: oauth_application.id,
                                          organisation_id: organisation.id,
                                          resource_owner_id: oauth_user.id,
                                          scopes: 'password',
                                          expires_in: Doorkeeper.configuration.access_token_expires_in,
                                          use_refresh_token: Doorkeeper.configuration.refresh_token_enabled?)
        end
        before do
          @job = create :job,
                        application: oauth_application,
                        start_at: 2.days.since,
                        params: {
                          headers: { platform_user_id: oauth_user.id, platform_organisation_id: organisation.id },
                          method: 'GET',
                          uri: 'http://www.example.com/v1/user'
                        }
        end

        it_behaves_like 'request: job succeeded'

        it_behaves_like 'request: job did not succeed'

        it_behaves_like 'request: job request result has an empty body'
      end

      context 'without organisation' do
        before do
          @job = create :job,
                        application: oauth_application,
                        start_at: 2.days.since,
                        params: {
                          headers: { platform_user_id: oauth_user.id },
                          method: 'GET',
                          uri: 'http://www.example.com/v1/user'
                        }
        end

        it_behaves_like 'request: job succeeded'

        it_behaves_like 'request: job did not succeed'

        it_behaves_like 'request: job request result has an empty body'
      end
    end
  end
end
