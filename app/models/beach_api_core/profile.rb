module BeachApiCore
  class Profile < ApplicationRecord
    include BeachApiCore::Concerns::AssetConcern
    belongs_to :user, inverse_of: :profile, class_name: 'BeachApiCore::User'
    has_one :avatar, class_name: 'BeachApiCore::Asset', as: :entity, inverse_of: :entity, dependent: :destroy
    has_many :profile_attributes, autosave: true, dependent: :destroy
    has_many :profile_custom_fields, through: :profile_attributes

    accepts_nested_attributes_for :avatar, allow_destroy: true, reject_if: :file_blank?

    attr_accessor :keepers

    validates :user, presence: true, uniqueness: true
    enum sex: %i(male female)

    def name
      "#{first_name} #{last_name}".strip
    end

    def _assign_attribute(k, v)
      public_send("#{k}=", v)
    rescue NameError, NoMethodError, ActiveModel::UnknownAttributeError
      if (profile_custom_field = ProfileCustomField.find_by(keeper: keepers, name: k)).present?
        profile_attribute = profile_attributes.lookup_or_initialize_by(profile_custom_field: profile_custom_field)
        profile_attribute.assign_attributes(value: v)
      elsif respond_to?("#{k}=")
        raise
      else
        raise ActiveRecord::UnknownAttributeError.new(self, k)
      end
    end
  end
end
