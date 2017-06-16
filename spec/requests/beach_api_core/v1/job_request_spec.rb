require 'rails_helper'

module BeachApiCore
  describe 'V1::Job', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'
    include_context 'controller actions permissions'

    JOB_KEYS = %i(id done last_run result).freeze

    describe 'when create' do
      before do
        @job_params = {
          params: {
            headers: { 'Authorization' => "Bearer #{access_token.token}" },
            method: 'GET',
            uri: beach_api_core.v1_user_path
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
          %i(headers method).each do |param|
            expect(Job.last.params[param]).to eq @job_params[:params][param]
          end
          expect(Job.last.params[:uri]).to include(@job_params[:params][:uri])
        end

        it 'should create a job with correct url' do
          job_params = @job_params.deep_merge(start_at: 2.days.since,
                                              params: { uri: Faker::Internet.url })
          expect { post beach_api_core.v1_jobs_path, params: { job: job_params }, headers: application_auth }
            .to change(JobRunner.jobs, :size).by(1).and change(Job, :count).by(1)
          expect(response.status).to eq 201
          expect(json_body[:job].keys).to contain_exactly(*JOB_KEYS)
          expect(JobRunner.jobs.last['args'].first).to eq Job.last.id
          job_params[:params].each { |param, value| expect(Job.last.params[param]).to eq value }
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
      context 'when invalid' do
        let(:job) { create :job }
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_job_path(job) }
        end
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_job_path(job), headers: invalid_app_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before { get beach_api_core.v1_job_path(job), headers: application_auth }
        end
      end

      context 'when valid' do
        before do
          @job_result = { "#{Faker::Lorem.word}": Faker::Lorem.word }
          @job = create :job, application: oauth_application, done: true, result: @job_result
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
    end

    describe 'when destroy' do
      context 'when invalid' do
        let(:job) { create :job }
        it_behaves_like 'an authenticated resource' do
          before { delete beach_api_core.v1_job_path(job) }
        end
        it_behaves_like 'an authenticated resource' do
          before { delete beach_api_core.v1_job_path(job), headers: invalid_app_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before { delete beach_api_core.v1_job_path(job), headers: application_auth }
        end
      end

      context 'when valid' do
        it 'should destroy a job' do
          job = create(:job, application: oauth_application)
          expect { delete beach_api_core.v1_job_path(job), headers: application_auth }.to change(Job, :count).by(-1)
          expect(response.status).to eq 200
          expect(json_body[:job].keys).to contain_exactly(*JOB_KEYS)
        end
      end
    end
  end
end
