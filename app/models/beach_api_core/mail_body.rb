module BeachApiCore
  class MailBody < ApplicationRecord
    belongs_to :application, class_name: 'Doorkeeper::Application'
    enum mail_type: { invitation:       0,
                      confirm_account:  1,
                      forgot_password:  2
    }

    validates  :application, presence: true
    validate   :css_hex_color
    validates  :mail_type, uniqueness: { scope: :application }

    def css_hex_color
      self.errors.add :text_color, "must be a valid CSS hex color code" if (!self.text_color.nil? && !self.text_color.empty?) && self.text_color.match(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i).nil?
      self.errors.add :button_color, "must be a valid CSS hex color code" if (!self.button_color.nil? && !self.button_color.empty?) && self.button_color.match(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i).nil?
      self.errors.add :button_text_color, "must be a valid CSS hex color code" if (!self.button_text_color.nil? && !self.button_text_color.empty?) && self.button_text_color.match(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i).nil?
      self.text_color = "#000000" if self.text_color.nil? || self.text_color.empty?
      self.button_color = "#3FD485" if self.button_color.nil? || self.button_color.empty?
      self.button_text_color = "#376E50" if self.button_text_color.nil? || self.button_text_color.empty?
    end
  end
end
