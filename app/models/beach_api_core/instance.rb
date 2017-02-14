module BeachApiCore
  class Instance < ApplicationRecord
    include Concerns::Downcasable
    include BeachApiCore::Concerns::KeeperRoles

    has_many :profile_custom_fields, as: :keeper, inverse_of: :keeper, dependent: :destroy

    validates :name, presence: true, uniqueness: true
    validate :validate_single_record

    acts_as_downcasable_on [:name]

    class << self
      def current
        @_current ||= (first || create(name: SecureRandom.uuid))
      end
    end

    private

    def validate_single_record
      errors.add(:base, "can't be created more than one record") if self.class.any?
    end
  end
end
