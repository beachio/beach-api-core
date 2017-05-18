module BeachApiCore
  class Favourite < ApplicationRecord
    belongs_to :user, inverse_of: :favourites
    belongs_to :favouritable, polymorphic: true

    validates :user, :favouritable, presence: true
    validates :user, uniqueness: { scope: [:favouritable_id, :favouritable_type] }

    scope :with_favouritable_type, -> (favouritable_type) { where(favouritable_type: favouritable_type) }
  end
end
