module BeachApiCore::Concerns::ScreensConcern
  extend ActiveSupport::Concern

  class_methods do
    
  end

  included do
    before_action :set_screen, only: [:show, :next, :prev]

    def show
      render json: @screen
    end

    def next
      @next = @screen.resource.screens.where("position > ?", @screen.position).first
      render json: @next
    end

    def prev
      @prev = @screen.resource.screens.where("position < ?", @screen.position).last
      render json: @prev
    end

    def main_flow
      @flow = BeachApiCore::Flow.main
      @screen = @flow.screens.first
      render json: @screen
    end

    def flow
      @flow = BeachApiCore::Flow.find(params[:flow_id])
      @screen = @flow.screens.first
      render json: @screen
    end

    private
      def set_screen
        @screen = BeachApiCore::Screen.find(params[:id])
      end
  end
end
