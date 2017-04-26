require 'rails_helper'

module BeachApiCore
  describe 'V1::Job', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when create' do
      before do
        @job_params = {
          start_at: 2.days.since,
          params: {
            bearer: access_token.token,
            method: 'GET',
            uri: beach_api_core.v1_user_path,
            input: {}
          }
        }
      end

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_jobs_path, params: { job: @job_params } }
      end

      it 'should create a job with given params' do
        expect do
          post beach_api_core.v1_jobs_path,
               params: { job: @job_params },
               headers: application_auth
        end.to change(JobRunner.jobs, :size).by(1)
                 .and change(Job, :count).by(1)
        expect(JobRunner.jobs.last['args'].first).to eq Job.last.id
      end
    end

    describe 'when destroy' do
      before do
        @job = create :job
      end

      it_behaves_like 'an authenticated resource' do
        before { delete beach_api_core.v1_job_path(@job) }
      end

      it 'shoyld destroy a job' do
        expect do
          delete beach_api_core.v1_job_path(@job),
                 headers: application_auth
        end.to change(Job, :count).by(-1)
      end
    end
  end
end
