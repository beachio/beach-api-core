module BeachApiCore
  class Role < ApplicationRecord
    include Concerns::Downcasable

    belongs_to :keeper, polymorphic: true
    has_many :assignments, inverse_of: :role, dependent: :destroy

    validates :name, :keeper, presence: true
    validates :name, uniqueness: { scope: [:keeper_id, :keeper_type] }

    acts_as_downcasable_on [:name]

    [:admin, :developer, :user].each do |basic_role|
      define_method "#{basic_role}?" do
        name == basic_role.to_s
      end
    end

    class << self
      [:admin, :developer, :user].each do |basic_role|
        define_method basic_role do |keeper = nil|
          find_by(name: basic_role, keeper: (keeper || Instance.current))
        end
      end
    end
  end
end
