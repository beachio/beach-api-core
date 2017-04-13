module BeachApiCore
  class V1::AssignmentsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    include AssignmentsDoc
    before_action :doorkeeper_authorize!, :check_user_membership!

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 404, desc: "User doesn't belong to current organisation"
    end

    def create
      authorize current_organisation, :update?
      result = BeachApiCore::AssignmentCreate.call(params: assignment_params, organisation: current_organisation)
      if result.success?
        render_json_success(result.assignment, result.status, root: :assignment)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def assignment_params
      params.require(:assignment).permit(:user_id, :role_id)
    end

    def check_user_membership!
      unless current_organisation.users.pluck(:id).include?(params[:assignment][:user_id].to_i)
        raise ActiveRecord::RecordNotFound.new('Not Found')
      end
    end
  end
end
