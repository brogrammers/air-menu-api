require 'spec_helper'

describe Api::V1::Orders::OrderItemsController do
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

    describe 'on existing order' do

      describe 'as a user' do

        describe 'owning the order' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope }

          it 'should respond with a HTTP 200 status code' do
            get :index, :order_id => 1
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the order' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope }

          it 'should respond with a HTTP 404 status code' do
            get :index, :order_id => 1
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

        end

      end

      describe 'as an owner' do

        describe 'owning the order' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope }

          before :each do
            get :index, :order_id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the order' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope }

          before :each do
            get :index, :order_id => 1
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

          it 'should return a model not found error message' do
            body = JSON.parse(response.body) rescue { }
            expect(body['error']['code']).to eq('model_not_found')
            expect(body['error']['model']).to eq('Order')
          end

        end

      end

    end

    describe 'on missing order' do

      let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 404 status code' do
        get :index, :order_id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

      it 'should return a model not found error message' do
        get :index, :order_id => 9999
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('model_not_found')
        expect(body['error']['model']).to eq('Order')
      end

    end

  end

  describe 'POST #create' do

    describe 'on existing order' do

      describe 'as a user' do

        describe 'owning the order' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :order_id => 1, :comment => 'comment', :count => 1, :menu_item_id => 1
          end

          it 'should respond with a HTTP 201 status code' do
            expect(response).to be_success
            expect(response.status).to eq(201)
          end

        end

        describe 'not owning the order' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :order_id => 1, :comment => 'comment', :count => 1, :menu_item_id => 1
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

          it 'should return a model not found error message' do
            body = JSON.parse(response.body) rescue { }
            expect(body['error']['code']).to eq('model_not_found')
            expect(body['error']['model']).to eq('Order')
          end

        end

      end

      describe 'as an owner' do

        describe 'owning the menu' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :order_id => 1, :comment => 'comment', :count => 1, :menu_item_id => 1
          end

          it 'should respond with a HTTP 201 status code' do
            expect(response).to be_success
            expect(response.status).to eq(201)
          end

          it 'should create a new order item object' do
            body = JSON.parse(response.body) rescue { }
            order_item = OrderItem.find(body['order_item']['id']) rescue nil
            expect(order_item).not_to be_nil
          end

        end

        describe 'not owning the menu' do

          describe 'on an active menu' do

            let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :order_id => 1, :comment => 'comment', :count => 1, :menu_item_id => 1
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

            it 'should return a model not found error message' do
              body = JSON.parse(response.body) rescue { }
              expect(body['error']['code']).to eq('model_not_found')
              expect(body['error']['model']).to eq('Order')
            end

          end

          describe 'on an inactive menu' do

            let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :order_id => 1, :comment => 'comment', :count => 1, :menu_item_id => 1
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

            it 'should return a model not found error message' do
              body = JSON.parse(response.body) rescue { }
              expect(body['error']['code']).to eq('model_not_found')
              expect(body['error']['model']).to eq('Order')
            end

          end

        end

      end

    end

    describe 'on missing menu' do

      let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 404 status code' do
        post :create, :order_id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

      it 'should return a model not found error message' do
        post :create, :order_id => 9999
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('model_not_found')
        expect(body['error']['model']).to eq('Order')
      end

    end

  end

end