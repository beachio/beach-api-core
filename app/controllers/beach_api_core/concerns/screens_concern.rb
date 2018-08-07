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
      @next = @screen.resource.screens.where("position > ?", @screen.position).order(:position).first
      render json: @next
    end

    def prev
      @prev = @screen.resource.screens.where("position < ?", @screen.position).order(:position).last
      render json: @prev
    end

    def main_flow
      @flow = BeachApiCore::Flow.main
      @screen = @flow.screens.first
      render json: @screen
    end

    def flow
      @flow = BeachApiCore::Flow.find_by(id: params[:flow_id]) || @bot.flow
      if @flow
        @screen = @flow.screens.first
        if @screen
          render json: @screen
        else
          render json: {msg: "Screen not found fot the flow"}, status: 404
        end
      else
        render json: {msg: "Flow not assigned to the bot"}, status: 404
      end
    end

    def bot
      render json: @bot
    end

    private
      def set_screen
        @screen = BeachApiCore::Screen.find(params[:id])
      end
  end
end
