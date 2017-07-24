module BeachApiCore
  class EmailCreate
    include Interactor

    before do
      Template.find_by!(name: context.email[:template], kind: :email) if context.email[:template].present?
    end

    def call
      BeachApiCore::EmailSender.perform_at(context.scheduled_time || DateTime.now.utc, email_params)
      context.status = :created
    end

    private

    def email_params
      params = context.email.slice(:from, :cc, :subject, :body, :plain)
      params[:to] = recipients
      if context.email[:template].present?
        params[:template] = context.email[:template]
        params[:template_params] = context.email[:template_params] || {}
      end
      params
    end

    def recipients
      if context.email[:user_ids]
        User.where(id: context.email[:user_ids]).pluck(:email).join(',')
      else
        context.email[:to]
      end
    end
  end
end
