require 'spec_helper'

describe Api::V1::NotificationsController do
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
           :order_items,
           :staff_kinds,
           :staff_members,
           :notifications

  before :each do
    controller.stub(:doorkeeper_token) { token }
    request.accept = 'application/json'
  end

  let(:basic_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }

  describe 'PUT #update' do

    describe 'on an existing notification' do

      describe 'owning the notification' do
        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => basic_scope, :revoked? => false, :expired? => false }

        before :each do
          put :update, :id => 1, :read => true
        end

        it 'should respond with a HTTP 200 status code' do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it 'should change the message to be read' do
          body = JSON.parse(response.body) rescue { }
          expect(body['notification']['read']).to be_true
        end

      end

      describe 'not owning the notification' do
        let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => basic_scope, :revoked? => false, :expired? => false }

        before :each do
          put :update, :id => 1, :read => true
        end

        it 'should respond with a HTTP 404 status code' do
          expect(response).to be_not_found
          expect(response.status).to eq(404)
        end

        it 'should return a model not found error message' do
          body = JSON.parse(response.body) rescue { }
          expect(body['error']['code']).to eq('model_not_found')
          expect(body['error']['model']).to eq('Notification')
        end

      end

    end

  end

end