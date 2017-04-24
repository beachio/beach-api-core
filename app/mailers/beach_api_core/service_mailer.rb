module BeachApiCore
  class ServiceMailer < ApplicationMailer
    def send!(opts = {})
      mail(opts)
    end
  end
end
