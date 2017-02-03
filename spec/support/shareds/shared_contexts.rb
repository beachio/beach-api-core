shared_context 'signed up developer' do
  let!(:developer) { create :developer }
  let!(:oauth_application) { create :oauth_application, owner: developer }
end

shared_context 'authenticated user' do
  let(:oauth_user) { create :oauth_user }
end

shared_context 'bearer token authentication' do
  let(:access_token) { Doorkeeper::AccessToken.create!(application: oauth_application,
                                                       resource_owner_id: oauth_user.id) }
  let(:developer_access_token) { Doorkeeper::AccessToken.create!(application: oauth_application,
                                                                 resource_owner_id: developer.id) }

  def bearer_auth
    { 'HTTP_AUTHORIZATION' => "Bearer #{access_token.token}" }
  end

  def developer_bearer_auth
    { 'HTTP_AUTHORIZATION' => "Bearer #{developer_access_token.token}" }
  end

  def application_auth
    { 'HTTP_AUTHORIZATION' => "application_id #{oauth_application.uid}, client_secret #{oauth_application.secret}" }
  end

  def invalid_app_auth
    { 'HTTP_AUTHORIZATION' => "application_id #{SecureRandom.hex(8)}, application_secret #{SecureRandom.hex(10)}" }
  end

  def invalid_bearer_auth
    { 'HTTP_AUTHORIZATION' => 'Bearer not a real token' }
  end
end
