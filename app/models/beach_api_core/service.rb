module BeachApiCore
  class Service < ApplicationRecord
    include Concerns::NameGenerator
    include BeachApiCore::Concerns::AssetConcern

    validates :name, :title, :service_category, presence: true

    belongs_to :service_category, class_name: 'BeachApiCore::ServiceCategory'
    has_one :icon, class_name: 'BeachApiCore::Asset', as: :entity, inverse_of: :entity, dependent: :destroy
    accepts_nested_attributes_for :icon, allow_destroy: true, reject_if: :file_blank?
    has_many :capabilities, dependent: :destroy
  end
end
