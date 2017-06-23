module BeachApiCore
  class Controller < ApplicationRecord
    belongs_to :service
    has_many :actions, dependent: :destroy
    accepts_nested_attributes_for :actions, allow_destroy: true

    scope(:with_action, lambda do |controller_classname, action_name|
      joins(:actions).where.has { (name == controller_classname) & (actions.name == action_name) }
    end)

    scope(:without_actions, lambda do |controller_classname|
      left_outer_joins(:actions).where(name: controller_classname).group(:id).when_having { actions.id.count == 0 }
    end)

    validates :name, :service, presence: true
  end
end
