def create_user_request(email: Faker::Internet.email, password: Faker::Internet.password,
                        params: {}, headers: application_auth)
  user = { email: email, password: password }.merge(params)
  post beach_api_core.v1_users_path, params: { user: user }, headers: headers
end
