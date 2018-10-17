module BeachApiCore
  class Instance < ApplicationRecord
    include BeachApiCore::Concerns::KeeperRoles

    has_many :profile_custom_fields, as: :keeper, inverse_of: :keeper, dependent: :destroy

    validates :name, presence: true, uniqueness: true
    validate :validate_single_record

    acts_as_downcasable_on :name
    acts_as_strippable_on :name

    class << self
      def current
        @_current ||= (first || create(name: SecureRandom.uuid))
      end

      def show_application_logo
        true
      end

      def show_instance_logo
        true
      end

      def body_style
        "background-color: #{background_color}; #{background_image}"
      end

      def invite_text
        "Please complete your registration to accept the invitation to <br> [GROUP_NAME]"
      end

      def background_color
        "#d8d8d8"
      end

      def background_image
        ""
      end

      def text_color
        "#50585c"
      end

      def success_text_color
        "#50585c"
      end

      def success_background_color
        "#d8d8d8"
      end

      def input_style
        "border: 1px solid #979797;"
      end

      def provided_text_color
        "#4a4a4a"
      end

      def invite_button_text
        "Complete Account Setup"
      end

      def form_background_color
        "#d8d8d8"
      end

      def success_invitation_background
        "#d8d8d8"
      end

      def application_logo
        'beach_api_core/beach-logo.png'
      end

      def instance_logo
        'beach_api_core/beach-logo.png'
      end

      def success_invitation_text
        "Success! Welcome to the [GROUP_TYPE] [GROUP_NAME]. <br><br> You can now log in with your Mineful ID."
      end

      def invitation_success_form_radius
        "0px"
      end

      def success_invitation_button_style
        "border-radius: 5px; background: black;"
      end

      def success_invitation_first_button_text
        "Get App"
      end

      def success_invitation_first_icon_type
        "fa fa-apple"
      end

      def success_invitation_first_button_link
        ""
      end

      def success_invitation_second_button_text
        "Download"
      end

      def success_invitation_second_icon_type
        "fa fa-cloud-download"
      end

      def success_invitation_second_button_link
        ""
      end

      def success_invitation_third_button_text
        "Visit Website"
      end

      def success_invitation_third_button_link
        "https://core.beach.io"
      end

      def success_invitation_third_icon_type
        ""
      end

      def restore_text
        "Please enter a new password"
      end

      def form_restore_border_radius
        "0px"
      end

      def restore_button_text
        "Set New Password"
      end

      def success_restore_text
        "Success! Your password has been changed. <br> <br> You can now log in with your Mineful ID"
      end

      def success_restore_border_radius
       "0px"
      end

      def success_button_first_available
        false
      end

      def success_button_second_available
        false
      end

      def success_button_third_available
        true
      end

      def button_style
        "color: #ffffff; background: #4a4a4a;"
      end

      def confirm_acc_text
        "Please set your new password to complete your account setup"
      end

      def form_confirm_border_radius
        "0px"
      end

      def confirm_button_text
        "Set Password"
      end

      def success_confirm_border_radius
        "0px"
      end

      def success_confirm_text
        "Success! Your account has been verified. <br> <br> You can now log in with your Mineful ID."
      end

    end

    private

    def validate_single_record
      errors.add(:base, :can_not_be_created_more_than_one) if self.class.where.not(id: id).present?
    end
  end
end
