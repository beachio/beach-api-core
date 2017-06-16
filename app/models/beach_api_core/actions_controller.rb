module BeachApiCore
  class ActionsController < ApplicationRecord
    belongs_to :controllers_service

    validates :name, :controllers_service, presence: true
  end
end
