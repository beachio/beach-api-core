module BeachApiCore
  class ProfileCustomField < ApplicationRecord
    include Concerns::NameGenerator
    belongs_to :keeper, polymorphic: true

    validates :name, presence: true, uniqueness: { scope: [:keeper_id, :keeper_type] }
    validates :title, :keeper, presence: true

    enum status: [:enabled, :disabled]

    after_initialize :set_defaults

    private

    def set_defaults
      self.status ||= :enabled
    end
  end
end
