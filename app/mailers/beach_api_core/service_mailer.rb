module BeachApiCore
  class ServiceMailer < ApplicationMailer
    layout false

    def send!(opts = {})
      mail(opts)
    end
  end
end
