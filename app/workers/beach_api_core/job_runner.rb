module BeachApiCore
  class JobRunner
    include ::Sidekiq::Worker
    sidekiq_options queue: 'job'
    sidekiq_options retry: 10

    def perform(id)
      return unless (job = Job.find_by_id(id)) && !job.done?
      result = run_job(job)
      job.update(done: true,
                 result: { status: result.code,
                           body: JSON.parse(result.body, symbolize_names: true) })
    end

    private

    def run_job(job)
      client = RestClient::Resource.new job.params[:uri],
                                        headers: headers(job.params[:bearer])
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
        raise 'Method not allowed'
      end
    end

    def normalize_opts!(opts)
      opts.symbolize_keys!
    end

    def headers(bearer)
      { 'Authorization' => "Bearer #{bearer}" }
    end
  end
end
