shared_examples_for 'request: job succeeded' do
  before do
    stub_request(:get, 'http://www.example.com/v1/user')
      .with(headers: { 'Authorization' => "Bearer #{access_token.token}" })
      .to_return(
        body: { user: BeachApiCore::UserSerializer.new(oauth_user) }.to_json,
        status: 200
      )
  end

  it do
    expect { subject.perform(@job.id) }.to(change { @job.reload.done? })
    expect(@job.result[:status].to_i).to eq 200
    expect(@job.result[:body][:user][:email]).to eq(oauth_user.email)
  end
end

shared_examples_for 'request: job did not succeed' do
  before do
    stub_request(:get, 'http://www.example.com/v1/user')
      .with(headers: { 'Authorization' => "Bearer #{access_token.token}" })
      .to_return(
        body: { message: 'You need to authorize first' }.to_json,
        status: 401
      )
  end

  it do
    expect { subject.perform(@job.id) }.to(change { @job.reload.done? })
    expect(@job.result[:status].to_i).to eq 401
    expect(@job.result[:body].keys).to contain_exactly(:message)
  end
end

shared_examples_for 'request: job request result has an empty body' do
  before do
    stub_request(:get, 'http://www.example.com/v1/user')
      .with(headers: { 'Authorization' => "Bearer #{access_token.token}" })
      .to_return(
        status: 401
      )
  end

  it do
    expect { subject.perform(@job.id) }.to(change { @job.reload.done? })
    expect(@job.result[:status].to_i).to eq 401
    expect(@job.result[:body]).to be_empty
  end
end

shared_examples_for 'request: returns chat' do |chat_keys|
  it do
    chat = BeachApiCore::Chat.last
    expect(response.status).to eq 200
    expect(json_body[:chat]).to be_present
    expect(json_body[:chat].keys).to contain_exactly(*chat_keys)
    expect(json_body[:chat][:id]).to eq chat.id
    expect(json_body[:chat][:users].map { |user| user[:id] }).to match_array chat.user_ids
  end
end


shared_examples_for 'request: returns chats' do |chat_keys|
  it do
    expect(response.status).to eq 200
    expect(json_body[:chats]).to be_present
    expect(json_body[:chats].size).to eq 1
    expect(json_body[:chats].first.keys).to contain_exactly(*chat_keys)
  end
end

shared_examples_for 'request: returns chat messages' do |message_keys|
  before do
    @chat = build(:chat, :with_one_user)
    @user ||= @chat.chats_users.first.user
    @chat.add_recipient(oauth_user)
    @message = build(:message, sender: @user)
    @chat.messages << @message
    @chat.chats_users.map(&:user).each { |user| @message.messages_users.build(user: user) }
    @chat.save!
    create(:chat, :with_chats_users, :with_messages)
  end

  it do
    expect(response.status).to eq 200
    expect(json_body[:messages]).to be_present
    expect(json_body[:messages].size).to eq 1
    expect(json_body[:messages].first.keys).to contain_exactly(*message_keys)
    expect(json_body[:messages].first[:sender][:id]).to eq @user.id
    expect(json_body[:messages].first[:message]).to eq @message.message
  end
end

shared_examples_for 'request: valid interaction create request' do |interaction_keys|
  it 'should create new interaction with correct fields' do
    expect do
      post beach_api_core.v1_interactions_path, params: { interaction: interaction_params }, headers: bearer_auth
    end.to change(BeachApiCore::Interaction, :count).by(1)
    interaction = BeachApiCore::Interaction.last
    expect(interaction.kind).to eq interaction_params[:kind]
    expect(interaction.user_id).to eq oauth_user.id
    %i(key values).each do |key|
      expect(interaction.interaction_attributes.first.send(key))
        .to eq interaction_params[:interaction_attributes_attributes].first[key]
    end
    %i(keeper_type keeper_id).each do |key|
      expect(interaction.interaction_keepers.first.send(key))
        .to eq interaction_params[:interaction_keepers_attributes].first[key]
    end
  end

  it 'should return interaction' do
    post beach_api_core.v1_interactions_path, params: { interaction: interaction_params }, headers: bearer_auth
    interaction = BeachApiCore::Interaction.last
    expect(response.status).to eq 200
    expect(json_body[:interaction]).to be_present
    expect(json_body[:interaction].keys).to contain_exactly(*interaction_keys)
    %i(id kind).each { |key| expect(json_body[:interaction][key]).to eq interaction.send(key) }
    expect(json_body[:interaction][:user][:id]).to eq oauth_user.id
  end
end

shared_examples 'request: entity message response' do
  it 'should return correct interaction' do
    expect(interaction_body.keys).to match_array BeachApiCore::INTERACTION_KEYS
    %i(id kind).each { |key| expect(interaction_body[key]).to eq @interaction.send(key) }
  end

  it 'should return correct user' do
    expect(interaction_body[:user].keys).to match_array BeachApiCore::INTERACTION_USER_KEYS
    BeachApiCore::INTERACTION_USER_KEYS.without(:avatar_url).each do |key|
      expect(interaction_body[:user][key]).to eq @interaction.user.send(key)
    end
  end

  it 'should return correct interaction keepers' do
    expect(interaction_body[:interaction_keepers].size).to eq 1
    expect(interaction_body[:interaction_keepers].first.keys).to match_array BeachApiCore::INTERACTION_KEEPER_KEYS
    BeachApiCore::INTERACTION_KEEPER_KEYS.each do |key|
      expect(interaction_body[:interaction_keepers].first[key])
        .to eq @interaction.interaction_keepers.first.send(key)
    end
  end

  it 'should return correct interaction attributes' do
    expect(interaction_body[:interaction_attributes].size).to eq 1
    expect(interaction_body[:interaction_attributes].first.keys)
      .to match_array BeachApiCore::INTERACTION_ATTRIBUTE_KEYS
    %i(id key).each do |key|
      expect(interaction_body[:interaction_attributes].first[key])
        .to eq @interaction.interaction_attributes.first.send(key)
    end
    expect(interaction_body[:interaction_attributes].first[:values].keys).to eq %i(text)
    expect(interaction_body[:interaction_attributes].first[:values][:text]).to eq message_text
  end
end
