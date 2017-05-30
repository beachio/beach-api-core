class UserContext
  attr_reader :user, :application

  def initialize(user, application)
    @user = user
    @application = application
  end
end
