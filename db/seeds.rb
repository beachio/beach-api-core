BeachApiCore::Role.destroy_all
BeachApiCore::Instance.destroy_all
BeachApiCore::User.destroy_all
BeachApiCore::Assignment.destroy_all
Doorkeeper::Application.destroy_all

ActiveRecord::Base.transaction do
  # Create instance record
  BeachApiCore::Instance.current

  # Create basic roles
  %i(admin developer).each do |name|
    role = BeachApiCore::Role.create(name: name)
    user = BeachApiCore::User.create(email: Faker::Internet.email, password: 'password', confirmed_at: Time.now)
    BeachApiCore::Assignment.create(role: role, keeper: BeachApiCore::Instance.current, user: user)
  end

  admin = BeachApiCore::User.joins(:roles).where(roles: {name: 'admin'}).first
  application = Doorkeeper::Application.create(name: Faker::Company.name, redirect_uri: Faker::Internet.redirect_uri, owner: BeachApiCore::Instance.current.developers.first, publisher: admin)
  admin.teams << BeachApiCore::Team.create(application: application, name: 'Test')

  service_categories = [{:name => "General", :services => []},
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
  service_categories.each do |service_cat|
    service_category = BeachApiCore::ServiceCategory.where(:name => service_cat[:name]).empty? ? BeachApiCore::ServiceCategory.create(:name => service_cat[:name]) : BeachApiCore::ServiceCategory.where(:name => service_cat[:name]).first
    service_cat[:services].each do |service_info|
      service = BeachApiCore::Service.where(:title => service_info[:title]).empty? ? BeachApiCore::Service.create(:title => service_info[:title], :description => service_info[:description],service_category_id: service_category.id) : BeachApiCore::Service.where(:title => service_info[:title]).first
      BeachApiCore::Capability.create(:application_id => application.id, :service_id => service.id) if BeachApiCore::Capability.where(:application_id => application.id, :service_id => service.id).empty?
    end
  end

  BeachApiCore::Setting.create(name: :noreply_from, keeper: application, value: Faker::Internet.email)
  BeachApiCore::Setting.create(name: :client_domain, keeper: application, value: Faker::Internet.redirect_uri)
end
