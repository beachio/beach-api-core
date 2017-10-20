module BeachApiCore
  class AccessLevel < ApplicationRecord
    include Concerns::NameGenerator

    validates :name, presence: true, uniqueness: true
    validates :name, :title, presence: true

    acts_as_downcasable_on :name
    acts_as_strippable_on :name

    has_many :user_accesses, inverse_of: :access_level, dependent: :destroy
  end
end
