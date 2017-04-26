module BeachApiCore
  class JobRunner
    include ::Sidekiq::Worker
    sidekiq_options queue: 'job'
    sidekiq_options retry: 10

    def perform(id)
      return unless (job = Job.find_by_id(id))
      client = RestClient::Resource.new job.params[:uri],
                                        headers: headers(job.params[:bearer])
      result = call_method(client, job.params[:method], job.params[:input])
      # @todo: Save job result
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
