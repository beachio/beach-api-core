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
        [:bearer, :method, :uri].each do |param|
          expect(Job.last.params[param]).to eq @job_params[:params][param]
        end
      end
    end

    describe 'when show' do
      before { @job = create :job }

      # it_behaves_like 'an authenticated resource' do
      #   before { delete beach_api_core.v1_job_path(@job) }
      # end

      it 'should show a job' do
        get beach_api_core.v1_job_path(@job),
            headers: application_auth
        expect(json_body[:job]).to be_present
        expect(json_body[:job].keys).to contain_exactly(:id, :done, :result)
        expect(json_body[:job][:id]).to eq @job.id
      end
    end

    describe 'when destroy' do
      before { @job = create :job }

      it_behaves_like 'an authenticated resource' do
        before { delete beach_api_core.v1_job_path(@job) }
      end

      it 'should destroy a job' do
        expect do
          delete beach_api_core.v1_job_path(@job),
                 headers: application_auth
        end.to change(Job, :count).by(-1)
      end
    end
  end
end
