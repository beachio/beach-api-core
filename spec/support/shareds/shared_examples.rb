shared_examples 'an authenticated resource' do
  it 'has status 401' do
    expect(response.status).to eq(401)
  end
end

shared_examples 'an forbidden resource' do
  it 'has status 403' do
    expect(response.status).to eq(403)
  end
end

shared_examples 'valid user response' do
  it do
    expect(json_body[:user]).to be_present
    expect(json_body[:user].keys).to contain_exactly(:id, :email, :username, :profile,
                                                     :organisations, :user_preferences)
    expect(json_body[:user][:profile].keys).to include(:id, :first_name, :last_name,
                                                       :birth_date, :sex, :time_zone,
                                                       :avatar_url)
  end
end

shared_examples 'valid team response' do
  it do
    expect(json_body[:team]).to be_present
    expect(json_body[:team].keys).to contain_exactly(:id, :name)
  end
end

shared_examples 'valid organisation response' do
  it do
    expect(json_body[:organisation]).to be_present
    expect(json_body[:organisation].keys).to contain_exactly(:id, :name, :logo_url, :logo_properties,
                                                             :current_user_roles)
  end
end
