module BeachApiCore
  class EmailSender
    include ::Sidekiq::Worker
    sidekiq_options queue: 'email'
    sidekiq_options retry: 10

    def perform(opts = {})
      normalize_opts!(opts)
      puts ApiMailer.custom(opts).deliver
    end

    private

    def normalize_opts!(opts)
      opts.symbolize_keys!
      opts.merge!(defaults) { |key, v1, v2| v1 }
    end

    def defaults
      # @todo: default "From" email?
      { from: 'noreply@example.com', body: '<body></body>' }
    end
  end
end
