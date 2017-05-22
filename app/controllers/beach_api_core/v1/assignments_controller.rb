module BeachApiCore
  class V1::AssignmentsController < BeachApiCore::V1::BaseController
    include AssignmentsDoc
    before_action :doorkeeper_authorize!
    before_action :check_user_membership!, only: :create

    resource_description do
      name t('activerecord.models.beach_api_core/assignment.other')
      error code: 403, desc: t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: t('api.resource_description.errors.unauthorized')
      error code: 404, desc: t('api.resource_description.errors.user_does_not_belong_to_organisation')
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
        head :no_content
      else
        render_json_error({ message: t('api.errors.could_not_remove',
                                       model: t('activerecord.models.beach_api_core/role.downcase')) }, :bad_request)
      end
    end

    private

    def assignment_params
      params.require(:assignment).permit(:user_id, :role_id)
    end

    def check_user_membership!
      raise ActiveRecord::RecordNotFound unless current_organisation.users.exists?(assignment_params[:user_id])
    end
  end
end
