module BeachApiCore
  class Flow < ApplicationRecord
    include BeachApiCore::Concerns::Screenable
    validates :name, presence: true

    belongs_to :directory

    def self.main
      find_by(main: true)
    end
  end
end
