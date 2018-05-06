class PermissionAdapter < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)
    return true if user.admin?

    if user.editor? && subject.to_s.include?("Flow")
      if action.in?([:edit, :update, :destroy]) && subject.locked?
        return false
      end
      return true
    end

    if user.scientist? && subject.to_s.include?("NuweHealth")
      return true
    end

    return false
  end

end