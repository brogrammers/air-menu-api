require 'spec_helper'

describe Api::V1::CompaniesController do
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

      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => ['admin'], :revoked? => false, :expired? => false }

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

    let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => ['user'], :revoked? => false, :expired? => false }

    describe 'on existing company' do

      it 'should respond with a HTTP 200 status code' do
        get :show, :id => 1
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

    end

    describe 'on missing company' do

      it 'should respond with a HTTP 404 status code' do
        get :show, :id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

      it 'should return a model not found error message' do
        get :show, :id => 9999
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('model_not_found')
        expect(body['error']['model']).to eq('Company')
      end

    end

  end

  describe 'PUT #update' do

    describe 'as a user' do

      describe 'not owning the company' do

        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => ['user'], :revoked? => false, :expired? => false }

        before :each do
          put :update, :id => 1, :name => 'name', :website => 'http://test.com', :address_1 => 'a1', :address_2 => 'a2', :city => 'city', :county => 'county', :country => 'IE'
        end

        it 'should respond with a HTTP 403 status code' do
          expect(response).to be_forbidden
          expect(response.status).to eq(403)
        end

        it 'should return a conflict error message' do
          body = JSON.parse(response.body) rescue { }
          expect(body['error']['code']).to eq('invalid_scope')
        end

      end

    end

    describe 'as an owner' do

      describe 'owning the company' do

        let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => Doorkeeper::OAuth::Scopes.from_array(['owner']), :revoked? => false, :expired? => false }

        before :each do
          put :update, :id => 1, :name => 'new name', :website => 'http://new.com', :address_1 => 'new a1', :address_2 => 'new a2', :city => 'new city', :county => 'new county', :country => 'IE'
        end

        it 'should respond with a HTTP 200 status code' do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it 'should have changed the companies attributes' do
          body = JSON.parse(response.body) rescue { }
          expect(body['company']['name']).to eq('new name')
          expect(body['company']['address']['address_1']).to eq('new a1')
          expect(body['company']['address']['address_2']).to eq('new a2')
          expect(body['company']['address']['city']).to eq('new city')
          expect(body['company']['address']['county']).to eq('new county')
          expect(body['company']['address']['country']).to eq('IE')
        end

      end

      describe 'not owning the company' do

        let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => Doorkeeper::OAuth::Scopes.from_array(['owner']), :revoked? => false, :expired? => false }

        before :each do
          put :update, :id => 1, :name => 'new name', :website => 'http://new.com', :address_1 => 'new a1', :address_2 => 'new a2', :city => 'new city', :county => 'new county', :country => 'IE'
        end

        it 'should respond with a HTTP 404 status code' do
          expect(response).to be_not_found
          expect(response.status).to eq(404)
        end

        it 'should return a model not found error message' do
          body = JSON.parse(response.body) rescue { }
          expect(body['error']['code']).to eq('model_not_found')
          expect(body['error']['model']).to eq('Company')
        end

      end

    end

  end

  describe 'POST #create' do

    describe 'as a user' do

      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => Doorkeeper::OAuth::Scopes.from_array(['user']), :revoked? => false, :expired? => false }

      before :each do
        post :create, :name => 'name', :website => 'http://test.com', :address_1 => 'a1', :address_2 => 'a2', :city => 'city', :county => 'county', :country => 'IE'
      end

      it 'should respond with a HTTP 201 status code' do
        expect(response).to be_successful
        expect(response.status).to eq(201)
      end

      it 'should create a new company object' do
        body = JSON.parse(response.body) rescue { }
        company = Company.find(body['company']['id']) rescue nil
        expect(company).not_to be_nil
      end

      it 'should create a new address object' do
        body = JSON.parse(response.body) rescue { }
        address = Address.find(body['company']['address']['id']) rescue nil
        expect(address).not_to be_nil
      end

    end

    describe 'as an owner' do

      let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => Doorkeeper::OAuth::Scopes.from_array(['user', 'owner']), :revoked? => false, :expired? => false }

      before :each do
        post :create, :name => 'name', :website => 'http://test.com', :address_1 => 'a1', :address_2 => 'a2', :city => 'city', :county => 'county', :country => 'IE'
      end

      it 'should respond with a HTTP 409 status code' do
        expect(response.status).to eq(409)
      end

      it 'should return a conflict error message' do
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('conflict')
        expect(body['error']['message']).to eq('already_owns_company')
      end

    end

  end

  describe 'DELETE #destroy' do

    describe 'as a user' do

      describe 'not owning the company' do

        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => Doorkeeper::OAuth::Scopes.from_array(['user']), :revoked? => false, :expired? => false }

        before :each do
          delete :destroy, :id => 1
        end

        it 'should respond with a HTTP 403 status code' do
          expect(response).to be_forbidden
          expect(response.status).to eq(403)
        end

        it 'should return a conflict error message' do
          body = JSON.parse(response.body) rescue { }
          expect(body['error']['code']).to eq('invalid_scope')
        end

      end

    end

    describe 'as an owner' do

      describe 'owning the company' do

        let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => Doorkeeper::OAuth::Scopes.from_array(['owner']), :revoked? => false, :expired? => false }

        before :each do
          delete :destroy, :id => 1
        end

        it 'should respond with a HTTP 200 status code' do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it 'should delete the company' do
          body = JSON.parse(response.body) rescue { }
          expect { Company.find body['company']['id'] }.to raise_error
        end

      end

      describe 'not owning the company' do

        let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => Doorkeeper::OAuth::Scopes.from_array(['owner']), :revoked? => false, :expired? => false }

        before :each do
          delete :destroy, :id => 1
        end

        it 'should respond with a HTTP 404 status code' do
          expect(response).to be_not_found
          expect(response.status).to eq(404)
        end

        it 'should return a model not found error message' do
          body = JSON.parse(response.body) rescue { }
          expect(body['error']['code']).to eq('model_not_found')
          expect(body['error']['model']).to eq('Company')
        end

      end

    end

  end
end