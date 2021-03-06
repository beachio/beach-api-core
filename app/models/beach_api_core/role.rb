module BeachApiCore
  class Role < ApplicationRecord
    has_many :assignments, inverse_of: :role, dependent: :destroy

    validates :name, presence: true, uniqueness: true

    acts_as_downcasable_on :name
    acts_as_strippable_on :name

    %i(admin developer user editor scientist).each do |basic_role|
      define_method "#{basic_role}?" do
        name == basic_role.to_s
      end
    end

    class << self
      %i(admin developer user editor scientist).each do |basic_role|
        define_method basic_role do
          find_by(name: basic_role)
        end
      end
    end
  end
end
