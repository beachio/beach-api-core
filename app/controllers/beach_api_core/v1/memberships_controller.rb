module BeachApiCore
  class V1::MembershipsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::GroupResourceConcern
    before_action :doorkeeper_authorize!
    before_action :find_group, only: [:create]

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    api :POST, '/memberships', 'Create a membership'
    param :membership, Hash, required: true do
      param :member_id, String, required: true
      param :member_type, %w(Team User), required: true
      param :group_id, String, required: true
      param :group_type, %w(Team Organisation), required: true
      param :owner, [true, false]
    end
    example "\"team(or organisation)\": #{apipie_team_response} \nfail: 'Errors Description'"
    def create
      result = BeachApiCore::MembershipCreate.call(params: membership_params, group: @group)

      if result.success?
        render_json_success(result.group, result.status, root: @group.class.to_s.underscore)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    api :DELETE, '/memberships/:id', 'Destroy membership'
    example "success: 'Membership was successfully deleted' \nfail: 'Could not remove membership'"
    def destroy
      @membership = Membership.find(params[:id])
      authorize @membership
      if @membership.destroy
        render_json_success({ message: 'Membership was successfully deleted' }, :ok)
      else
        render_json_error({ message: 'Could not remove membership' }, :bad_request)
      end
    end

    private

    def membership_params
      params.require(:membership).permit(:member_id, :member_type, :owner)
    end
  end
end
