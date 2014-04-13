require 'spec_helper'

describe Api::V1::Me::DevicesController do
  render_views
  fixtures :addresses,
           :companies,
           :identities,
           :menu_items,
           :menu_sections,
           :menus,
           :restaurants,
           :users,
           :orders,
           :staff_kinds,
           :staff_members

  before :each do
    controller.stub(:doorkeeper_token) { token }
    request.accept = 'application/json'
  end

  let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
  let(:none_scope) { Doorkeeper::OAuth::Scopes.from_array [] }
  let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }
  let(:device_parameters) { {:name => 'name', :uuid => 'uuid', :token => 'token', :platform => 'ios'} }

  describe 'GET #index' do

    before :each do
      get :index
    end

    describe 'with user scope' do

      it 'should respond with a HTTP 200 status code' do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

    end

    describe 'without user scope' do

      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => none_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 403 status code' do
        expect(response).to be_forbidden
        expect(response.status).to eq(403)
      end

      it 'should return a forbidden error message' do
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('invalid_scope')
      end

    end

  end

  describe 'POST #create' do

    before :each do
      post :create, device_parameters
    end

    describe 'with user scope' do

      it 'should respond with a HTTP 201 status code' do
        expect(response).to be_success
        expect(response.status).to eq(201)
      end

      it 'should create a device object' do
        body = JSON.parse(response.body) rescue { }
        id = body['device']['id']
        expect { Device.find(id) }.not_to raise_error
      end

      it 'should save all the attributes' do
        body = JSON.parse(response.body) rescue { }
        device = Device.find body['device']['id']
        expect(device.name).to eq(device_parameters[:name])
        expect(device.uuid).to eq(device_parameters[:uuid])
        expect(device.token).to eq(device_parameters[:token])
        expect(device.platform).to eq(device_parameters[:platform])
      end

    end

    describe 'without user scope' do

      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => none_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 403 status code' do
        expect(response).to be_forbidden
        expect(response.status).to eq(403)
      end

      it 'should return a forbidden error message' do
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('invalid_scope')
      end

    end

  end

end