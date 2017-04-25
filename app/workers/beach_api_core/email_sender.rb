module BeachApiCore
  class EmailSender
    include ::Sidekiq::Worker
    sidekiq_options queue: 'email'
    sidekiq_options retry: 10

    def perform(opts = {})
      normalize_opts!(opts)
      ApiMailer.custom(opts).deliver
    end

    private

    def normalize_opts!(opts)
      opts.symbolize_keys!
      opts.merge!(defaults) { |key, v1, v2| v1 || v2 }
    end

    def defaults
      { from: ENV['EMAIL_FROM'], body: '<body></body>' }
    end
  end
end
