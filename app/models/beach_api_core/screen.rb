module BeachApiCore
  class Screen < ApplicationRecord
    belongs_to :resource, polymorphic: true
    has_paper_trail


    def next_screen
      resource.screens.where("position > ?", position).order(:position).first
    end

    def prev_screen
      resource.screens.where("position < ?", position).order(:position).last
    end

    def by_flow flow_id
      BeachApiCore::Flow.find(flow_id).screens.first rescue nil
    end

    def by_id id
      BeachApiCore::Screen.find(id) rescue nil
    end

    def call_action action
      screen = case action["type"]
      when "NEXT_SCREEN"
        next_screen
      when "PREV_SCREEN"
        prev_screen
      when "OPEN_FLOW"
        by_flow(action["payload"]["flow_id"])
      when "GO_TO_SCREEN_BY_ID"
        by_id(action["payload"]["screen_id"])
      end
      
      if block_given?
        yield(screen)
      end

      screen
    end
  end
end
