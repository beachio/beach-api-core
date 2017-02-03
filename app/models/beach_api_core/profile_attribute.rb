module BeachApiCore
  class ProfileAttribute < ApplicationRecord
    belongs_to :profile
    belongs_to :profile_custom_field

    validates :value, presence: true
    validates :profile, uniqueness: { scope: :profile_custom_field_id }
  end
end
