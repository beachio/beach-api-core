module BeachApiCore
  class Project < ApplicationRecord
    belongs_to :user, class_name: 'BeachApiCore::User', inverse_of: :projects
    belongs_to :organisation, class_name: 'BeachApiCore::Organisation', inverse_of: :projects
    has_many :project_keepers, class_name: 'BeachApiCore::ProjectKeeper', inverse_of: :project, dependent: :destroy

    validates :name, :user, :organisation, presence: true

    accepts_nested_attributes_for :project_keepers, allow_destroy: true
  end
end
