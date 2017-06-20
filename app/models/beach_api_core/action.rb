module BeachApiCore
  class Action < ApplicationRecord
    belongs_to :controller

    validates :name, :controller, presence: true
  end
end
