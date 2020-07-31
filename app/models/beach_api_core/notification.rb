module BeachApiCore
  class Notification < ApplicationRecord
    belongs_to :user
    enum kind: { email: 0, ws: 1 }
  end
end
