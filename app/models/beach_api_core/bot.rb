module BeachApiCore
  class Bot < ApplicationRecord
    include BeachApiCore::Concerns::AssetConcern
    after_create :create_directory

    has_one :avatar, class_name: 'BeachApiCore::Asset', as: :entity, inverse_of: :entity, dependent: :destroy
    belongs_to :application, class_name: 'Doorkeeper::Application'
    has_one :user, through: :application, source: :owner, source_type: "BeachApiCore::User"
    belongs_to :flow
    has_many :directories
    has_many :available_flows, through: :directories, class_name: "BeachApiCore::Flow", source: :flows


    accepts_nested_attributes_for :avatar, allow_destroy: true, reject_if: :file_blank?
    validates :name, presence: true, uniqueness: true
    validates :application_id, presence: true, uniqueness: true

    private
      def create_directory
        self.directories.create(name: "App")
      end
  end
end
