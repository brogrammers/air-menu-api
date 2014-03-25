require 'spec_helper'

describe Api::V1::MeController do
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

    let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => ['user', 'basic'] }

    it 'should respond with a HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    describe 'as an user' do

      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => ['user', 'basic'] }

      it 'should return the proper type in the response body' do
        get :index
        body = JSON.parse(response.body) rescue { }
        expect(body['me']['type']).to eq('User')
      end

    end

    describe 'as an owner' do

      let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => ['user', 'basic', 'owner'] }

      it 'should return the proper type in the response body' do
        get :index
        body = JSON.parse(response.body) rescue { }
        expect(body['me']['type']).to eq('Owner')
      end

    end

    describe 'as an staff member' do

      let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => ['user', 'basic'] }

      it 'should return the proper type in the response body' do
        get :index
        body = JSON.parse(response.body) rescue { }
        expect(body['me']['type']).to eq('StaffMember')
      end

    end

  end
end