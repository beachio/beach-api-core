module BeachApiCore
  class ServiceCategory < ApplicationRecord
    validates_presence_of :name

    has_many :services
  end
end
