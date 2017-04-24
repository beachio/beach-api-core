require 'rails_helper'

module BeachApiCore
  describe 'V1::Email', type: :request do
    include_context 'signed up developer'
    include_context 'bearer token authentication'

    describe 'when create' do
      before do
        @email_params = {
          from: Faker::Internet.email,
          to: Faker::Internet.email,
          cc: Faker::Internet.email,
          subject: Faker::Lorem.sentence,
          body: "<body>#{Faker::Lorem.sentence}</body>"
        }
      end

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_emails_path, params: { email: @email_params } }
      end

      it 'should send an email with given params' do
        post beach_api_core.v1_emails_path,
             params: { email: @email_params },
             headers: application_auth
        # @todo: check for action mailer deliveries after sidekiq send out an email
      end
    end
  end
end
