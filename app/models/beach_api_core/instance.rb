module BeachApiCore
  class Instance < ApplicationRecord
    include BeachApiCore::Concerns::KeeperRoles

    has_many :profile_custom_fields, as: :keeper, inverse_of: :keeper, dependent: :destroy

    validates :name, presence: true, uniqueness: true
    validate :validate_single_record

    acts_as_downcasable_on :name
    acts_as_strippable_on :name

    class << self
      def current
        @_current ||= (first || create(name: SecureRandom.uuid))
      end
    end

    private

    def validate_single_record
      errors.add(:base, :can_not_be_created_more_than_one) if self.class.where.not(id: id).present?
    end
  end
end
