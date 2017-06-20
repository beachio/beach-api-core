module BeachApiCore
  class Controller < ApplicationRecord
    belongs_to :service
    has_many :actions, dependent: :destroy
    accepts_nested_attributes_for :actions, allow_destroy: true

    validates :name, :service, presence: true
  end
end
