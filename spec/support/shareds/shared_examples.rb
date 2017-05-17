shared_examples 'an authenticated resource' do
  it 'has status 401' do
    expect(response.status).to eq 401
  end
end

shared_examples 'an forbidden resource' do
  it 'has status 403' do
    expect(response.status).to eq 403
  end
end

shared_examples 'resource not found' do
  it 'has status 404' do
    expect(response.status).to eq 404
  end
end

shared_examples 'valid user response' do
  it do
    expect(json_body[:user]).to be_present
    expect(json_body[:user].keys).to contain_exactly(*BeachApiCore::USER_KEYS)
    expect(json_body[:user][:profile].keys).to include(*BeachApiCore::PROFILE_KEYS)
  end
end

shared_examples 'valid team response' do
  it do
    expect(json_body[:team]).to be_present
    expect(json_body[:team].keys).to contain_exactly(*BeachApiCore::TEAM_KEYS)
  end
end

shared_examples 'valid organisation response' do
  it do
    expect(json_body[:organisation]).to be_present
    expect(json_body[:organisation].keys).to contain_exactly(*BeachApiCore::ORGANISATION_KEYS)
  end
end
