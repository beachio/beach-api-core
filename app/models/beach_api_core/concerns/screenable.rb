module BeachApiCore::Concerns::Screenable
  extend ActiveSupport::Concern

  included do
    has_many :screens, class_name: "BeachApiCore::Screen", as: :resource
    accepts_nested_attributes_for :screens
  end
end