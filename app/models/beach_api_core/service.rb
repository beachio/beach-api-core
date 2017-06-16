module BeachApiCore
  class Service < ApplicationRecord
    include Concerns::NameGenerator
    include BeachApiCore::Concerns::AssetConcern

    validates :name, :title, :service_category, presence: true

    belongs_to :service_category, class_name: 'BeachApiCore::ServiceCategory'
    has_one :icon, class_name: 'BeachApiCore::Asset', as: :entity, inverse_of: :entity, dependent: :destroy
    accepts_nested_attributes_for :icon, allow_destroy: true, reject_if: :file_blank?
    has_many :capabilities
    has_many :controllers_services, dependent: :destroy, autosave: true
    accepts_nested_attributes_for :controllers_services, allow_destroy: true

    before_save :mark_controllers_for_destruction

    def controller?(controller_name)
      controllers_services.exists?(name: controller_name)
    end

    def action?(controller_name, action_name)
      controllers_services.joins(:actions_controllers)
                          .exists?(name: controller_name, beach_api_core_actions_controllers: { name: action_name })
    end

    private

    def mark_controllers_for_destruction
      controllers_services.select(&:persisted?).each(&:mark_for_destruction)
    end
  end
end
