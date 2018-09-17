module BeachApiCore
  module ApplicationServiceHelper
    class << self

      def service_categories
        [{:name => "General", :services => []},
         {:name => "Developer Tools", services: [{:title => "Teams", :description => 'Manage Teams and Groups of Users'},
                                                 {:title => "Organisations", :description => 'Managing Organisations settings'},
                                                 {:title => "Projects", :description => 'Organisations and User Project service'},
                                                 {:title => "Jobs", :description => 'Scheduled tasks service'},
                                                 {:title => "Chats", :description => 'Realtime message service'},
                                                 {:title => "Data Models", :description => 'Flexible Data model abstractions and persistence'},
                                                 {:title => "Services and Capabilities", :description => 'Managing Service and Capability permissions for Doorkeeper Applications'},
                                                 {:title => "Images and Assets", :description => 'Uploading Images and Assets to Coinstash CDN'},
                                                 {:title => "Security Pro", :description => 'Permissions Management and Access Levels for Users'},
                                                 {:title => "Webhooks", :description => 'Managing Webhooks via the Coinstash Platform'},
                                                 {:title => "Emails", :description => 'Managing system emails from the Coinstash Platform'},
                                                 {:title => "Users Basic", :description => ''},
                                                 {:title => "Users Pro", :description => 'Full Access for Managing Users'},
                                                 {:title => "Applications", :description => ''},
                                                 {:title => "Notifications", :description => ''}]}
        ]
      end


      def add_capabilities_to_applications
        applications = Doorkeeper::Application.all
        unless applications.empty?
          service_categories.each do |service_cat|
            service_category = BeachApiCore::ServiceCategory.where(:name => service_cat[:name]).empty? ? BeachApiCore::ServiceCategory.create(:name => service_cat[:name]) : BeachApiCore::ServiceCategory.where(:name => service_cat[:name]).first
            service_cat[:services].each do |service_info|
              applications.each do |application|
                service = BeachApiCore::Service.where(:title => service_info[:title]).empty? ? BeachApiCore::Service.create(:title => service_info[:title], :description => service_info[:description],service_category_id: service_category.id) : BeachApiCore::Service.where(:title => service_info[:title]).first
                BeachApiCore::Capability.create(:application_id => application.id, :service_id => service.id) if BeachApiCore::Capability.where(:application_id => application.id, :service_id => service.id).empty?
              end
            end
          end
        end
      end

    end
  end
end