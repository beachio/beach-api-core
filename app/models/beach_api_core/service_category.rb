module BeachApiCore
  class ServiceCategory < ApplicationRecord
    validates :name, presence: true

    has_many :services
  end
end
