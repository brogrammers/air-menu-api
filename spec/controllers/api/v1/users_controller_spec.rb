require 'spec_helper'

describe Api::V1::UsersController do
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

  describe 'GET #index' do

    describe 'with admin scope' do

      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => ['admin'] }

      it 'should respond with a HTTP 200 status code' do
        get :index
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

    end

    describe 'without admin scope' do

      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => [], :revoked? => false, :expired? => false }

      before :each do
        get :index
      end

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

  describe 'GET #show' do

    let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => ['user'] }

    describe 'on existing user' do

      it 'should respond with a HTTP 200 status code' do
        get :show, :id => 1
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

    end

    describe 'on missing user' do

      it 'should respond with a HTTP 404 status code' do
        get :show, :id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

      it 'should return a model not found error message' do
        get :show, :id => 9999
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('model_not_found')
        expect(body['error']['model']).to eq('User')
      end

    end

  end

  describe 'POST #create' do

    describe 'with trusted scope' do

      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => ['trusted'] }

      before :each do
        post :create, :name => 'name', :username => 'username', :password => 'password', :email => 'email@email.com', :phone => '+353832345623'
      end

      it 'should respond with a HTTP 201 status code' do
        expect(response).to be_success
        expect(response.status).to eq(201)
      end

      it 'should create a new company object' do
        body = JSON.parse(response.body) rescue { }
        user = User.find(body['user']['id']) rescue nil
        expect(user).not_to be_nil
      end

      it 'should create a new identity object' do
        body = JSON.parse(response.body) rescue { }
        identity = User.find(body['user']['id']).identity rescue nil
        expect(identity).not_to be_nil
      end

      it 'should include phone attribute' do
        body = JSON.parse(response.body) rescue { }
        user = User.find(body['user']['id']) rescue nil
        expect(user.phone).to eq('+353832345623')
      end

    end

    describe 'without trusted scope' do

      let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => [], :revoked? => false, :expired? => false }

      before :each do
        post :create, :name => 'name', :username => 'username', :password => 'password', :email => 'email@email.com'
      end

      #TODO: change back to trusted scope
      xit 'should respond with a HTTP 403 status code' do
        expect(response.status).to eq(403)
      end

      xit 'should return a conflict error message' do
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('invalid_scope')
      end

    end

  end
end