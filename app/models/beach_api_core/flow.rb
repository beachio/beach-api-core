module BeachApiCore
  class Flow < ApplicationRecord
    include BeachApiCore::Concerns::Screenable
    validates :name, presence: true
  end
end
