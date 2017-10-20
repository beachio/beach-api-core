module BeachApiCore
  class Plan < ApplicationRecord
    validates :name, presence: true

    has_many :organisation_plans, dependent: :destroy
    has_many :plan_items, dependent: :destroy


  end
end
