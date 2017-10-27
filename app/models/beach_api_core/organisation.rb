module BeachApiCore
  class Organisation < ApplicationRecord
    include BeachApiCore::Concerns::AssetConcern
    include BeachApiCore::Concerns::GenerateImageConcern
    validates :name, :application, presence: true

    belongs_to :application, class_name: 'Doorkeeper::Application'
    has_many :memberships, as: :group, inverse_of: :group
    has_many :users, through: :memberships, source: :member, source_type: 'BeachApiCore::User'
    has_many :teams, through: :memberships, source: :member, source_type: 'BeachApiCore::Team'
    has_many :invitations, as: :group, inverse_of: :group
    has_many :assignments, as: :keeper, inverse_of: :keeper
    has_many :projects, class_name: 'BeachApiCore::Project', inverse_of: :organisation, dependent: :destroy
    has_many :user_accesses, as: :keeper, inverse_of: :keeper
    has_one :organisation_plan, dependent: :destroy
    has_one :plan, through: :organisation_plan
    has_one :logo_image, class_name: 'BeachApiCore::Asset', as: :entity, inverse_of: :entity, dependent: :destroy
    
    accepts_nested_attributes_for :logo_image, allow_destroy: true, reject_if: :file_blank?
    accepts_nested_attributes_for :organisation_plan,
                                  allow_destroy: true, reject_if: proc { |attr| attr[:plan_id].blank? }

    before_save -> { generate_image(:logo_image, color: logo_properties && logo_properties['color']) },
                if: proc { generate_image? }

    def owners
      users.where(Membership.table_name => { owner: true })
    end

    def generate_image?
      logo_image.blank? || ((name_changed? || logo_properties_changed?) && logo_image.generated?)
    end
  end
end
