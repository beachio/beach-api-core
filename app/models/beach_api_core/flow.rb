module BeachApiCore
  class Flow < ApplicationRecord
    include BeachApiCore::Concerns::Screenable
    validates :name, presence: true

    belongs_to :directory
  end
end
