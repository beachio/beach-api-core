module BeachApiCore
  class ApiMailer < ApplicationMailer
    def custom(opts)
      body = opts.delete(:body)
      plain = opts.delete(:plain) || ActionView::Base.full_sanitizer.sanitize(body)
      mail(opts) do |format|
        format.text { render plain: plain }
        format.html { render html: body.html_safe }
      end
    end
  end
end
