module BeachApiCore::Concerns::V1::GroupResourceConcern
  extend ActiveSupport::Concern

  included do
    def find_group
      @group = "BeachApiCore::#{params[:group_type].classify}".constantize.find(params[:group_id])
    end
  end
end
