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
