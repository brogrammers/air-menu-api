require 'spec_helper'

describe Api::V1::Me::NotificationsController do
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

  let(:basic_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }
  let(:none_scope) { Doorkeeper::OAuth::Scopes.from_array [] }

  describe 'GET #index' do

    before :each do
      get :index
    end

    describe 'with basic scope' do
      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => basic_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 200 status code' do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

    end

    describe 'without basic scope' do
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