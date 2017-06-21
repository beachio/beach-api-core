BeachApiCore::Role.destroy_all
BeachApiCore::Instance.destroy_all
BeachApiCore::User.destroy_all
Doorkeeper::Application.destroy_all

# Create instance record
BeachApiCore::Instance.current

# Create basic roles
%i(admin developer).each do |name|
  role = BeachApiCore::Role.create(name: name)
  user = BeachApiCore::User.create(email: Faker::Internet.email, password: Faker::Internet.password)
  BeachApiCore::Assignment.create(role: role, keeper: BeachApiCore::Instance.current, user: user)
end

application = Doorkeeper::Application.create(name: Faker::Company.name, redirect_uri: Faker::Internet.redirect_uri,
                                             owner: BeachApiCore::Instance.current.developers.first)
BeachApiCore::Setting.create(name: :noreply_from, keeper: application, value: Faker::Internet.email)
BeachApiCore::Setting.create(name: :client_domain, keeper: application, value: Faker::Internet.redirect_uri)
