module BeachApiCore
  class JobRunner
    include ::Sidekiq::Worker
    sidekiq_options queue: 'job'
    sidekiq_options retry: 10

    def perform(id)
      return unless (job = Job.find_by_id(id)) && !job.done?
      # @todo: some better way to get root url?
      url = URI.join(Rails.application.routes.url_helpers.beach_api_core_url,
                     job.params['uri'])
      client = RestClient::Resource.new url.to_s,
                                        headers: headers(job.params['bearer'])
      result = call_method(client, job.params['method'], job.params['input'])
      job.update(done: true, result: { status: result.code, body: result.body })
    end

    private

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
      { 'HTTP-AUTHORIZATION' => "Bearer #{bearer}" }
    end
  end
end
