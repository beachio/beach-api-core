module BeachApiCore
  class V1::AssignmentsController < BeachApiCore::V1::BaseController
    include AssignmentsDoc
    before_action :doorkeeper_authorize!
    before_action :check_user_membership!, only: :create

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

    def destroy
      authorize current_organisation, :update?
      @assignment = current_organisation.assignments.find(params[:id])
      if @assignment.destroy
        render_json_success({ message: 'Role has been removed' }, :ok)
      else
        render_json_error({ message: 'Could not remove role' }, :bad_request)
      end
    end

    private

    def assignment_params
      params.require(:assignment).permit(:user_id, :role_id)
    end

    def check_user_membership!
      user = User.find(params[:assignment][:user_id].to_i)
      raise ActiveRecord::RecordNotFound.new('Not Found') unless current_organisation.users.include?(user)
    end
  end
end
