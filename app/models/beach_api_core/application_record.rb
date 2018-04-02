module BeachApiCore
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    class << self
      def permited_actions
        @@permited_actions
      end

      def permit_actions *actions
        @@permited_actions = actions
      end

      def execute_action action_name, current_user, data, handler
        if permited_actions.include?(action_name.to_sym)
          self.send(action_name, current_user, data, handler)
        end
      end
    end

    def permited_actions
      @@permited_actions
    end

    def execute_action action_name, current_user, data, handler
      if permited_actions.include?(action_name.to_sym)
        send(action_name, current_user, data, handler)
      end
    end
  end
end
