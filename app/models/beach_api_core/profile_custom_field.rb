module BeachApiCore
  class ProfileCustomField < ApplicationRecord
    include Concerns::NameGenerator
    belongs_to :keeper, polymorphic: true

    validates :name, presence: true, uniqueness: { scope: [:keeper_id, :keeper_type] }
    validates :title, presence: true

    enum status: [:active, :inactive]
  end
end
