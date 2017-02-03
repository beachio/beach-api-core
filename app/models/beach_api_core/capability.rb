module BeachApiCore
  class Capability < ApplicationRecord
    belongs_to :application, class_name: 'Doorkeeper::Application'
    belongs_to :service

    validates :application, :service, presence: true
  end
end
