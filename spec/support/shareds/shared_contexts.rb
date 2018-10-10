shared_context 'signed up developer' do
  let!(:developer) { create :developer }
  let!(:oauth_application) { create :oauth_application, owner: developer }
end


shared_context 'signed up admin' do
  let!(:admin) {create :admin}
  let!(:oauth_application) { create :oauth_application, owner: admin }
end

shared_context 'authenticated user' do
  let(:oauth_user) { create :oauth_user }
end

shared_context 'bearer token authentication' do
  let(:access_token) do
    Doorkeeper::AccessToken.find_or_create_for(oauth_application,
                                               oauth_user.id,
                                               Doorkeeper::OAuth::Scopes.from_string('password'),
                                               Doorkeeper.configuration.access_token_expires_in,
                                               Doorkeeper.configuration.refresh_token_enabled?)
  end
  let(:developer_access_token) do
    Doorkeeper::AccessToken.find_or_create_for(oauth_application,
                                               developer.id,
                                               Doorkeeper::OAuth::Scopes.from_string('password'),
                                               Doorkeeper.configuration.access_token_expires_in,
                                               Doorkeeper.configuration.refresh_token_enabled?)
  end

  def bearer_auth
    { 'HTTP_AUTHORIZATION' => "Bearer #{access_token.token}" }
  end

  def developer_bearer_auth
    { 'HTTP_AUTHORIZATION' => "Bearer #{developer_access_token.token}" }
  end

  def application_auth
    { 'HTTP_AUTHORIZATION' => "application_id #{oauth_application.uid}, client_secret #{oauth_application.secret}"}
  end

  def application_auth_json
    { 'HTTP_AUTHORIZATION' => "application_id #{oauth_application.uid}, client_secret #{oauth_application.secret}", 'ACCEPT' =>  'application/json', 'HTTP_ACCEPT' => 'application/json',  'CONTENT_TYPE' => 'application/json' }
  end

  def invalid_app_auth
    { 'HTTP_AUTHORIZATION' => "application_id #{SecureRandom.hex(8)}, application_secret #{SecureRandom.hex(10)}" }
  end

  def invalid_app_auth_json
    { 'HTTP_AUTHORIZATION' => "application_id #{SecureRandom.hex(8)}, application_secret #{SecureRandom.hex(10)}", 'ACCEPT' =>  'application/json', 'HTTP_ACCEPT' => 'application/json',  'CONTENT_TYPE' => 'application/json' }
  end

  def invalid_bearer_auth
    { 'HTTP_AUTHORIZATION' => 'Bearer not a real token' }
  end
end
