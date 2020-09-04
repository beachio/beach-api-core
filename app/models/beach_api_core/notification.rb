module BeachApiCore
  class Notification < ApplicationRecord
    belongs_to :user
    enum kind: { email: 0, ws: 1 }
    enum notify_type: {
      create_proj: 0,
      update_proj: 1,
      destroy_proj: 2,
      create_chart: 3,
      update_chart: 4,
      destroy_chart: 5,
      create_organisation: 6
    }
  end
end
