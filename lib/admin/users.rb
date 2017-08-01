ActiveAdmin.register BeachApiCore::User, as: 'User' do
  menu priority: 51, parent: 'Users'

  permit_params do
    [:email, :username, :password,
     profile_attributes: custom_fields_params.concat([:id, :first_name, :last_name,
                                                      :sex, :birth_date, :time_zone,
                                                      avatar_attributes: %i(id file)]),
     team_memberships_attributes: %i(id group_id owner _destroy),
     organisation_memberships_attributes: %i(id group_id owner),
     assignments_attributes: %i(id role_id keeper_id keeper_type _destroy)]
  end

  index do
    id_column
    column :email
    actions
  end

  filter :email

  form do |f|
    f.object.build_profile if f.object.profile.blank?
    f.inputs t('active_admin.details', model: t('activerecord.models.user.one')), class: 'inputs js-keepers' do
      f.input :email
      f.input :username, required: false
      f.input :password, required: true
      f.fields_for :profile do |p|
        p.object.build_avatar if p.object.avatar.blank?
        p.input :first_name, required: false
        p.input :last_name, required: false
        p.input :sex, as: :select, collection: BeachApiCore::Profile.sexes.keys, required: false
        p.input :birth_date, as: :datepicker, required: false
        p.input :time_zone, as: :select, collection: ActiveSupport::TimeZone.all.map(&:name), required: false
        li do
          f.label :avatar
          p.fields_for :avatar do |a|
            span { a.attachment_field :file, direct: true }
          end
          if p.object.avatar.file.present?
            div { image_tag attachment_url(p.object.avatar, :file, :fill, 150, 150) }
          end
        end
      end
      f.fields_for :profile_attributes do |p|
        profile_custom_fields.each do |field|
          p.input field.name, required: false, label: field.title,
                              input_html: { value: value_for_user(f.object, field) }
        end
      end
      f.has_many :assignments, allow_destroy: true,
                               heading: t('activerecord.models.role.other'), class: 'js-keeper_wrapper' do |t|
        t.input :keeper_type, as: :hidden, input_html: { class: 'js-keeper_type' }
        t.input :keeper_id, as: :hidden, input_html: { class: 'js-keeper_id' }
        t.input :role, collection: BeachApiCore::Role.all, include_blank: false
        t.input :keeper, as: :select,
                         collection: options_for_select(keepers, "#{t.object.keeper_type}##{t.object.keeper_id}"),
                         input_html: { class: 'js-keeper_select', name: :keeper }
      end
      f.has_many :team_memberships, allow_destroy: true, heading: t('activerecord.models.team.other') do |t|
        t.input :group, as: :select, collection: BeachApiCore::Team.all, label: t('activerecord.models.team.one')
        t.input :owner
      end
      f.has_many :organisation_memberships, allow_destroy: true,
                                            heading: t('activerecord.models.organisation.other') do |o|
        o.input :group, as: :select, collection: BeachApiCore::Organisation.all,
                        label: t('activerecord.models.organisation.one')
        o.input :owner
      end
    end
    f.actions
  end

  show do |user|
    attributes_table do
      row :id
      row :email
      row :username
      tag_row :status
      attributes_table_for user.profile do
        row :first_name
        row :last_name
        row :birth_date
        row :sex
        row :time_zone
        if user.profile.avatar.present?
          row :avatar do
            image_tag attachment_url(user.profile.avatar, :file, :fill, 150, 150)
          end
        end
      end
      profile_custom_fields.each do |field|
        row field.title do
          value_for_user(user, field)
        end
      end
      if user.user_preferences.any?
        row :preferences do
          div do
            user.user_preferences.each do |preference|
              div do
                span { "#{preference.application.name}: " }
                span { preference.preferences }
              end
            end
          end
        end
      end
      if user.assignments.any?
        row :roles do
          user.assignments.map { |assignment| "#{assignment.role.name}: #{keeper_name(assignment.keeper)}" }
        end
      end
      if user.teams.any?
        row :teams do
          safe_join(user.teams.map do |team|
            link_to team.name, admin_team_path(team)
          end, ', ')
        end
      end
      row :organisations do
        safe_join(user.organisations.map do |org|
          link_to org.name, admin_organisation_path(org)
        end, ', ')
      end
    end
  end

  controller do
    helper_method :profile_custom_fields
    before_action :set_keepers, only: %i(create update)

    def profile_custom_fields
      # @todo: different custom fields for users in organizations?
      BeachApiCore::ProfileCustomField.enabled.where(keeper: BeachApiCore::Instance.current)
    end

    def custom_fields_params
      profile_custom_fields.pluck(:name)
    end

    private

    def set_keepers
      @user = params[:id] ? resource : BeachApiCore::User.new
      @user.profile.keepers = [BeachApiCore::Instance.current]
      @user.assign_attributes permitted_params[:user] if @user.new_record?
    end
  end
end
