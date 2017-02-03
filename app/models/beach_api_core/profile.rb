module BeachApiCore
  class Profile < ApplicationRecord
    belongs_to :user
    has_one :avatar, class_name: 'Asset', as: :entity, inverse_of: :entity, dependent: :destroy
    has_many :profile_attributes, autosave: true
    has_many :profile_custom_fields, through: :profile_attributes

    accepts_nested_attributes_for :avatar, allow_destroy: true

    attr_accessor :keepers

    validates :user, presence: true, uniqueness: true
    enum sex: [:male, :female]

    def _assign_attribute(k, v)
      public_send("#{k}=", v)
    rescue NoMethodError, NameError
      if (profile_custom_field = ProfileCustomField.find_by(keeper: keepers, name: k)).present?
        profile_attribute = profile_attributes.find_or_initialize_by(profile_custom_field: profile_custom_field)
        profile_attribute.assign_attributes(value: v)
      else
        if respond_to?("#{k}=")
          raise
        else
          raise ActiveRecord::UnknownAttributeError.new(self, k)
        end
      end
    end
  end
end
