require 'spec_helper'

describe Api::V1::Companies::RestaurantsController do
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

    describe 'on existing company' do

      describe 'as a user' do

        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => ['owner'] }

        it 'should respond with a HTTP 200 status code' do
          get :index, :company_id => 1
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

      end

      describe 'as an owner' do

        let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => ['user', 'owner'], :revoked? => false, :expired? => false }

        before :each do
          get :index, :company_id => 1
        end

        it 'should respond with a HTTP 200 status code' do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

      end

    end

    describe 'on missing company' do

      let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 404 status code' do
        get :index, :company_id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

      it 'should return a model not found error message' do
        get :index, :company_id => 9999
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('model_not_found')
        expect(body['error']['model']).to eq('Company')
      end

    end

  end

  describe 'POST #create' do

    describe 'on existing company' do

      describe 'as a user' do

        let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        before :each do
          post :create, :company_id => 1
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

      describe 'as an owner' do

        describe 'owning the company' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :company_id => 1, :name => 'Restaurant', :description => 'description', :loyalty => false, :conversion_rate => 0.0, :remote_order => false, :address_1 => 'a1', :address_2 => 'a2', :city => 'city', :county => 'county', :country => 'IE', :latitude => 56.3443, :longitude => 6.78234, :category => 'blah'
          end

          it 'should respond with a HTTP 201 status code' do
            expect(response).to be_success
            expect(response.status).to eq(201)
          end

          it 'should add the correct attributes' do
            body = JSON.parse(response.body) rescue { }
            expect(body['restaurant']['name']).to eq('Restaurant')
            expect(body['restaurant']['description']).to eq('description')
            expect(body['restaurant']['loyalty']).to eq(false)
            expect(body['restaurant']['conversion_rate']).to eq(0.0)
            expect(body['restaurant']['remote_order']).to eq(false)
            expect(body['restaurant']['category']).to eq('blah')
          end

          it 'should create a new restaurant object' do
            body = JSON.parse(response.body) rescue { }
            restaurant = Restaurant.find(body['restaurant']['id']) rescue nil
            expect(restaurant).not_to be_nil
          end

          it 'should create a new address object' do
            body = JSON.parse(response.body) rescue { }
            address = Address.find(body['restaurant']['address']['id']) rescue nil
            expect(address).not_to be_nil
          end

          it 'should create new location object' do
            body = JSON.parse(response.body) rescue { }
            location = Address.find(body['restaurant']['location']['id']) rescue nil
            expect(location).not_to be_nil
          end

        end

      end

    end

    describe 'on missing company' do

      let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
      let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 404 status code' do
        post :create, :company_id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

      it 'should return a model not found error message' do
        get :create, :company_id => 9999
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('model_not_found')
        expect(body['error']['model']).to eq('Company')
      end

    end

  end
end