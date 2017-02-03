module BeachApiCore
  class Service < ApplicationRecord
    include Concerns::NameGenerator

    validates :name, :title, presence: true

    belongs_to :service_category
    has_one :icon, class_name: 'Asset', as: :entity, inverse_of: :entity, dependent: :destroy
    accepts_nested_attributes_for :icon, allow_destroy: true
    has_many :capabilities
  end
end
