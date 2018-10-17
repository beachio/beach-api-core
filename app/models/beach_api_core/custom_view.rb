module BeachApiCore
  class CustomView < ApplicationRecord
    belongs_to :application, class_name: 'Doorkeeper::Application'
    enum view_type: { invitation:       0,
                      confirm_account:  1,
                      forgot_password:  2
    }

    validates  :application, :view_type, presence: true
    validate   :css_hex_color
    validates  :view_type, uniqueness: { scope: :application }

    def css_hex_color
      self.errors.add :text_color, "must be a valid CSS hex color code" if (!self.text_color.nil? && !self.text_color.empty?) && self.text_color.match(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i).nil?
      self.errors.add :success_text_color, "must be a valid CSS hex color code" if (!self.success_text_color.nil? && !self.success_text_color.empty?) && self.success_text_color.match(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i).nil?
      self.errors.add :error_text_color, "must be a valid CSS hex color code" if (!self.error_text_color.nil? && !self.error_text_color.empty?) && self.error_text_color.match(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i).nil?
      self.errors.add :form_background_color, "must be a valid CSS hex color code" if (!self.form_background_color.nil? && !self.form_background_color.empty?) && self.form_background_color.match(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i).nil?
      self.errors.add :success_background_color, "must be a valid CSS hex color code" if (!self.success_background_color.nil? && !self.success_background_color.empty?) && self.success_background_color.match(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i).nil?
      self.text_color = BeachApiCore::Instance.text_color if self.text_color.nil? || self.text_color.empty?
      self.form_background_color = BeachApiCore::Instance.form_background_color if self.form_background_color.nil? || self.form_background_color.empty?
      self.success_background_color = BeachApiCore::Instance.success_background_color if self.success_background_color.nil? || self.success_background_color.empty?
    end
  end
end
