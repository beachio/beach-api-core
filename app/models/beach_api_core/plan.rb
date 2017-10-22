module BeachApiCore
  class Plan < ApplicationRecord
    validates :name, presence: true

    has_many :organisation_plans, dependent: :destroy
    has_many :plan_items, dependent: :destroy

    accepts_nested_attributes_for :plan_items, allow_destroy: true
  end
end
