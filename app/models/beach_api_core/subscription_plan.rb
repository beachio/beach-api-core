module BeachApiCore
  class SubscriptionPlan < ApplicationRecord
    include ::Payola::Plan

    def redirect_path(_)
      '/'
    end
  end
end
