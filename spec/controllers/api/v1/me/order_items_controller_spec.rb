require 'spec_helper'

describe Api::V1::Me::OrdersController do
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
  let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['get_orders'] }
  let(:owner_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
  let(:none_scope) { Doorkeeper::OAuth::Scopes.from_array [] }
  let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

  describe 'GET #index' do

    describe 'as a user' do
      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

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

    describe 'as an owner' do
      let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

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

    describe 'as a staff member' do
      let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

      describe 'with state parameter' do

        before :each do
          get :index, :state => 'open'
        end

        it 'should respond with a HTTP 200 status code' do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

      end

      describe 'without state parameter' do

        before :each do
          get :index
        end

        it 'should respond with a HTTP 400 status code' do
          expect(response.status).to eq(400)
        end

        it 'should return a forbidden error message' do
          body = JSON.parse(response.body) rescue { }
          expect(body['error']['code']).to eq('parameters')
          expect(body['error']['parameters']).to include('state')
        end

      end

    end

  end
end
