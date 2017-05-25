module BeachApiCore
  class JobRunner
    include ::Sidekiq::Worker
    sidekiq_options queue: 'job'
    sidekiq_options retry: 10

    def perform(id)
      return unless (job = Job.find_by(id: id)) && !job.done?
      result = run_job(job)
      job.update(done: true,
                 last_run: Time.zone.now,
                 result: { status: result.code,
                           body: parse(result.body) })
    end

    private

    def run_job(job)
      client = RestClient::Resource.new job.params[:uri],
                                        headers: job.params[:headers]
      call_method(client, job.params[:method], job.params[:input])
    rescue RestClient::Exception => e
      e.response
    end

    def call_method(client, method, params = {})
      case method.downcase
      when 'post', 'put', 'patch'
        client.send(method.downcase.to_sym, params)
      when 'get', 'delete'
        client.send(method.downcase.to_sym)
      else
        raise I18n.t('errors.method_not_allowed')
      end
    end

    def normalize_opts!(opts)
      opts.symbolize_keys!
    end

    def parse(body)
      JSON.parse(body, symbolize_names: true)
    rescue JSON::ParserError
      body
    end
  end
end
