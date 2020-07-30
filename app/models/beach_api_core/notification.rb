module BeachApiCore
  class Notification < ApplicationRecord
    belongs_to :user
  end
end
