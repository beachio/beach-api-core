require 'rails_helper'

module BeachApiCore
  describe 'V1::Email', type: :request do
    include_context 'signed up developer'
    include_context 'bearer token authentication'

    describe 'when create' do
      before do
        content = Faker::Lorem.sentence
        @email_params = {
          from: Faker::Internet.email,
          to: Faker::Internet.email,
          cc: Faker::Internet.email,
          subject: Faker::Lorem.sentence,
          body: "<body>#{content}</body>",
          plain: content
        }
      end

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_emails_path, params: { email: @email_params } }
      end

      it 'should queue an email with given params' do
        expect do
          post beach_api_core.v1_emails_path,
               params: { email: @email_params },
               headers: application_auth
        end.to change(EmailSender.jobs, :size).by(1)
        expect(response.status).to eq 201
        expect(EmailSender.jobs.last['args'].first.symbolize_keys).to eq @email_params
      end
    end
  end
end
