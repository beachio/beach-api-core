module BeachApiCore::NotificationInteractor
  class Create
    include Interactor
    
    before do
      context.title =
        case context.model
        when BeachApiCore::Organisation
          "Organisation '#{context.model.name}'"
        end
    end

    def call
      return unless context.title
      context.notification = 
        BeachApiCore::Notification.create({
          message: "#{context.title} was created",
          user: context.user,
          kind: :email,
          sent: false
        })
    end
  end
end
