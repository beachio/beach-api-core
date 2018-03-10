module BeachApiCore::Concerns::Screenable
  extend ActiveSupport::Concern

  included do
    has_many :screens, ->{order(:position)}, class_name: "BeachApiCore::Screen", as: :resource
    accepts_nested_attributes_for :screens, allow_destroy: true
  end
end