module BeachApiCore
  class ProjectKeeper < ApplicationRecord
    belongs_to :project, class_name: 'BeachApiCore::Project', inverse_of: :project_keepers
    belongs_to :keeper, polymorphic: true

    validates :project, :keeper, presence: true
    validates :project, uniqueness: { scope: [:keeper_id, :keeper_type] }
  end
end
