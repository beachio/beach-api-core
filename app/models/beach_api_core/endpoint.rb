module BeachApiCore
  class Endpoint < ApplicationRecord
    validates_presence_of :model, :action_name, :request_type, :on
    validates_uniqueness_of :model, scope: [:action_name, :request_type, :on]
  end
end
