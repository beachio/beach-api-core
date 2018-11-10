require 'rails_helper'

module BeachApiCore
  describe 'V1::Device', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'


    it 'should return devices list' do
      BeachApiCore::Device.create(name: 'Mac', user: oauth_user)
      BeachApiCore::Device.create(name: 'PC', user: oauth_user)

      get beach_api_core.v1_devices_path, headers: bearer_auth

      expect(response.status).to eq 200
      expect(json_body[:devices].pluck(:id)).to eq oauth_user.devices.pluck(:id)
    end

    it 'should return device info by id' do
      device = BeachApiCore::Device.create(name: 'Mac', user: oauth_user)

      get beach_api_core.v1_device_path(device), headers: bearer_auth

      expect(response.status).to eq 200
      expect(json_body[:device][:id]).to eq device.id
    end


    it 'should return created device' do
      name = ["Linux Server", "Windows", "Mac"].sample
      params = {
        device: {
          name: name
        }
      }

      post beach_api_core.v1_devices_path, params: params, headers: bearer_auth

      expect(response.status).to eq 201
      expect(json_body[:device][:name]).to eq name
    end

    it 'should update device' do
      device = BeachApiCore::Device.create(name: 'Mac', user: oauth_user)

      params = {
        device: {
          name: Faker::Lorem.sentence
        }
      }

      put beach_api_core.v1_device_path(device), params: params, headers: bearer_auth

      expect(response.status).to eq 200
      expect(json_body[:device][:name]).to eq params[:device][:name]
    end

    it 'should delete device' do
      device = BeachApiCore::Device.create(name: 'Mac', user: oauth_user)

      delete beach_api_core.v1_device_path(device), headers: bearer_auth

      deleted_device = BeachApiCore::Device.find_by(id: device.id)

      expect(response.status).to eq 200
      expect(deleted_device).to eq nil
    end
  end

  
end
