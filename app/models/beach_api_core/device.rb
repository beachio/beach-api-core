module BeachApiCore
  class Device < ApplicationRecord
    belongs_to :user
    belongs_to :application, class_name: "Doorkeeper::Application"
    has_many :rewards, class_name: "BeachApiCore::Reward", as: :reward_to, dependent: :destroy
    has_many :scores, class_name: "BeachApiCore::DeviceScore", :foreign_key => 'device_id', dependent: :destroy
    before_create :set_token

    validates_presence_of :name

    def add_scores_to_application(application_id, scores)
      device_score = BeachApiCore::DeviceScore.find_by(:device_id => self.id, :application => application_id)
      device_score.nil? ? BeachApiCore::DeviceScore.create(:device_id => self.id, :application_id => application_id, :scores => scores) :
          device_score.update_attribute(:scores, device_score.scores + scores)
    end

    private
      def set_token
        self.token = SecureRandom.hex if !token
      end
  end
end
