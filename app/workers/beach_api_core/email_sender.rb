module BeachApiCore
  class EmailSender
    include ::Sidekiq::Worker
    sidekiq_options queue: 'email'
    sidekiq_options retry: 10

    def perform(opts = {})
      normalize_opts!(opts)
      parse_body!(opts) if opts[:template] && !opts[:mailer]
      if opts[:mailer]
        normalize_template_params!(opts[:template_params])
        mail_options = opts.except(:mailer, :template, :body)
        if BeachApiCore.allowed_mailer_actions.include?("#{opts[:mailer]}.#{opts[:template]}")
          opts[:mailer].constantize.send(opts[:template], mail_options).deliver
        end
      else
        ApiMailer.custom(opts).deliver
      end
    end

    private

    def normalize_opts!(opts)
      opts.symbolize_keys!
      opts.merge!(defaults) { |_, v1, v2| v1 || v2 }
    end

    def normalize_template_params!(template_params)
      if template_params
        template_params.symbolize_keys!
        template_params[:url] = URI.join(BeachApiCore::Setting.client_domain(keeper: current_application),
                                         template_params[:url]).to_s
      end
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
