module BeachApiCore
  class EmailSender
    include ::Sidekiq::Worker
    sidekiq_options queue: 'email'
    sidekiq_options retry: 10

    def perform(application_id, opts = {})
      normalize_opts!(opts)
      parse_body!(opts) if opts[:template] && !opts[:mailer]
      if opts[:mailer]
        mail_options = opts.except(:mailer, :template, :body)
        application = Doorkeeper::Application.find(application_id)
        mail_options[:template_params][:base_url] = BeachApiCore::Setting.client_domain(keeper: application)
        if BeachApiCore.allowed_mailer_actions.include?("#{opts[:mailer]}.#{opts[:template]}")
          opts[:mailer].constantize.send(opts[:template], mail_options).deliver
        end
      else
        ApiMailer.custom(opts).deliver
      end
    end

    private

    def normalize_opts!(opts)
      opts.deep_symbolize_keys!
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
