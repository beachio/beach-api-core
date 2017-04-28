require 'rails_helper'

module BeachApiCore
  describe JobRunner do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'should send a request with params from given job' do
      let!(:job) do
        create :job,
               start_at: 2.days.since,
               params: {
                 bearer: access_token.token,
                 method: 'GET',
                 uri: 'http://www.example.com/v1/user'
               }
      end

      before do
        stub_request(:get, 'http://www.example.com/v1/user')
          .with(headers: { 'Authorization' => "Bearer #{access_token.token}" })
          .to_return(
            body: { user: UserSerializer.new(oauth_user) }.to_json,
            status: 200
          )
      end

      it do
        expect { subject.perform(job.id) }.to change { job.reload.done? }
        expect(job.result[:status].to_i).to eq 200
        expect(job.result[:body][:user][:email]).to eq(oauth_user.email)
      end
    end
  end
end
