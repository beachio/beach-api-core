module BeachApiCore
  class Service < ApplicationRecord
    include Concerns::NameGenerator
    include BeachApiCore::Concerns::AssetConcern

    validates :name, :title, :service_category, presence: true

    belongs_to :service_category, class_name: 'BeachApiCore::ServiceCategory'
    has_one :icon, class_name: 'BeachApiCore::Asset', as: :entity, inverse_of: :entity, dependent: :destroy
    accepts_nested_attributes_for :icon, allow_destroy: true, reject_if: :file_blank?
    has_many :capabilities
    has_many :controllers, dependent: :destroy, autosave: true
    accepts_nested_attributes_for :controllers, allow_destroy: true

    before_save :mark_controllers_for_destruction

    def controller?(controller_name)
      controllers.exists?(name: controller_name)
    end

    def action?(controller_name, action_name)
      controllers.joins(:actions).exists?(name: controller_name, beach_api_core_actions: { name: action_name })
    end

    private

    def mark_controllers_for_destruction
      controllers.select(&:persisted?).each(&:mark_for_destruction)
    end
  end
end
