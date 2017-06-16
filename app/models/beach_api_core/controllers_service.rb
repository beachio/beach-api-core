module BeachApiCore
  class ControllersService < ApplicationRecord
    belongs_to :service
    has_many :actions_controllers, dependent: :destroy
    accepts_nested_attributes_for :actions_controllers, allow_destroy: true

    validates :name, :service, presence: true
  end
end
