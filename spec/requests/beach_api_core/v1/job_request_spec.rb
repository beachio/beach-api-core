require 'rails_helper'

module BeachApiCore
  describe 'V1::Job', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    JOB_KEYS = [:id, :done, :last_run, :result].freeze

    describe 'when create' do
      before do
        @job_params = {
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

      context 'when scheduled job' do
        it 'should create a job with given params' do
          expect do
            post beach_api_core.v1_jobs_path,
                 params: { job: @job_params.merge(start_at: 2.days.since) },
                 headers: application_auth
          end.to change(JobRunner.jobs, :size).by(1)
                   .and change(Job, :count).by(1)
          expect(response.status).to eq 201
          expect(json_body[:job].keys).to contain_exactly(*JOB_KEYS)
          expect(JobRunner.jobs.last['args'].first).to eq Job.last.id
          [:bearer, :method].each do |param|
            expect(Job.last.params[param]).to eq @job_params[:params][param]
          end
          expect(Job.last.params[:uri]).to include(@job_params[:params][:uri])
        end
      end

      context 'when cron job' do
        it 'should not create a sidekiq job' do
          expect do
            post beach_api_core.v1_jobs_path,
                 params: { job: @job_params.merge(every: '1.hour') },
                 headers: application_auth
          end.to change(JobRunner.jobs, :size).by(0)
                   .and change(Job, :count).by(1)
          expect(response.status).to eq 201
          expect(json_body[:job].keys).to contain_exactly(*JOB_KEYS)
          expect(Job.last.every).to eq '1.hour'
        end
      end
    end

    describe 'when show' do
      before do
        @job_result = { "#{Faker::Lorem.word}": "#{Faker::Lorem.word}" }
        @job = create :job, done: true, result: @job_result
      end

      it_behaves_like 'an authenticated resource' do
        before { delete beach_api_core.v1_job_path(@job) }
      end

      it 'should show a job' do
        get beach_api_core.v1_job_path(@job),
            headers: application_auth
        expect(response.status).to eq 200
        expect(json_body[:job]).to be_present
        expect(json_body[:job].keys).to contain_exactly(*JOB_KEYS)
        expect(json_body[:job][:id]).to eq @job.id
        expect(json_body[:job][:result]).to eq @job_result
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
        expect(response.status).to eq 200
        expect(json_body[:job].keys).to contain_exactly(*JOB_KEYS)
      end
    end
  end
end
