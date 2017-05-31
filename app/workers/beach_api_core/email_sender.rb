module BeachApiCore
  class EmailSender
    include ::Sidekiq::Worker
    sidekiq_options queue: 'email'
    sidekiq_options retry: 10

    def perform(opts = {})
      normalize_opts!(opts)
      parse_body!(opts) if opts[:template]
      ApiMailer.custom(opts).deliver
    end

    private

    def normalize_opts!(opts)
      opts.symbolize_keys!
      opts.merge!(defaults) { |_, v1, v2| v1 || v2 }
    end

    def parse_body!(opts)
      template = Template.find_by!(name: opts.delete(:template), kind: :email)
      opts[:body] = TemplateParser.new(template, opts.delete(:template_params)).call
      opts.delete(:plain) if opts[:body]
    end

    def defaults
      { from: ENV['EMAIL_API_FROM'] || ENV['EMAIL_FROM'],
        body: '<body></body>' }
    end
  end
end
