require 'spec_helper'

describe Api::V1::Restaurants::OrdersController do
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
  let(:admin_scope) { Doorkeeper::OAuth::Scopes.from_array ['admin'] }
  let(:owner_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
  let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['get_current_orders', 'add_orders'] }

  describe 'GET #index' do

    describe 'on existing restaurant' do

      describe 'as a user' do

        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        before :each do
          get :index, :restaurant_id => 1
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

        before :each do
          get :index, :restaurant_id => 1
        end

        describe 'owning the restaurant' do

          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the restaurant' do

          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

          it 'should respond with a HTTP 403 status code' do
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end

          it 'should return a forbidden error message' do
            body = JSON.parse(response.body) rescue { }
            expect(body['error']['code']).to eq('forbidden')
            expect(body['error']['message']).to eq('ownership_failure')
          end

        end

      end

      describe 'as a staff member' do

        before :each do
          get :index, :restaurant_id => 1
        end

        describe 'owning the restaurant' do

          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the restaurant' do

          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          it 'should respond with a HTTP 403 status code' do
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end

          it 'should return a forbidden error message' do
            body = JSON.parse(response.body) rescue { }
            expect(body['error']['code']).to eq('forbidden')
            expect(body['error']['message']).to eq('ownership_failure')
          end

        end

      end

    end

    describe 'on missing restaurant' do

      before :each do
        get :index, :restaurant_id => 9999
      end

      describe 'as an owner' do

        let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

        it 'should respond with a HTTP 404 status code' do
          expect(response).to be_not_found
          expect(response.status).to eq(404)
        end

      end

    end

  end

  describe 'POST #create' do

    describe 'on existing restaurant' do

      before :each do
        post :create, :restaurant_id => 1
      end

      describe 'as a user' do

        describe 'with an existing order' do

          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

          it 'should respond with a HTTP 403 status code' do
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end

          it 'should return a forbidden error message' do
            body = JSON.parse(response.body) rescue { }
            expect(body['error']['code']).to eq('forbidden')
            expect(body['error']['message']).to eq('too_many_orders')
          end

        end

        describe 'without an existing order' do

          let(:token) { double :accessible? => true, :resource_owner_id => 5, :scopes => user_scope, :revoked? => false, :expired? => false }

          it 'should respond with a HTTP 201 status code' do
            expect(response).to be_success
            expect(response.status).to eq(201)
          end

        end

      end

      describe 'as an owner' do

        describe 'owning the restaurant' do

          describe 'without an existing order' do

            let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :restaurant_id => 1, :table_number => '3'
            end

            it 'should respond with a HTTP 201 status code' do
              expect(response).to be_success
              expect(response.status).to eq(201)
            end

            it 'should add the table number' do
              body = JSON.parse(response.body) rescue { }
              expect(body['order']['table_number']).to eq('3')
            end

          end

          describe 'with an existing order' do

            let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :restaurant_id => 2
            end

            it 'should respond with a HTTP 201 status code' do
              expect(response).to be_success
              expect(response.status).to eq(201)
            end

          end

          describe 'with more than one existing order' do

            let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :restaurant_id => 2
            end

            it 'should respond with a HTTP 201 status code' do
              expect(response).to be_success
              expect(response.status).to eq(201)
            end

          end

        end

        describe 'not owning the restaurant' do

          describe 'without an existing order' do

            let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

            it 'should respond with a HTTP 403 status code' do
              post :create, :restaurant_id => 2
              expect(response).to be_forbidden
              expect(response.status).to eq(403)
            end

            it 'should return a forbidden error message' do
              post :create, :restaurant_id => 2
              body = JSON.parse(response.body) rescue { }
              expect(body['error']['code']).to eq('forbidden')
              expect(body['error']['message']).to eq('too_many_orders')
            end

          end

          describe 'with an existing order' do

            let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :restaurant_id => 1
            end

            it 'should respond with a HTTP 403 status code' do
              expect(response).to be_forbidden
              expect(response.status).to eq(403)
            end

            it 'should return a forbidden error message' do
              body = JSON.parse(response.body) rescue { }
              expect(body['error']['code']).to eq('forbidden')
              expect(body['error']['message']).to eq('too_many_orders')
            end

          end

          describe 'with more than one existing order' do

            let(:token) { double :accessible? => true, :resource_owner_id => 4, :scopes => owner_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :restaurant_id => 1
            end

            it 'should respond with a HTTP 403 status code' do
              expect(response).to be_forbidden
              expect(response.status).to eq(403)
            end

            it 'should return a forbidden error message' do
              body = JSON.parse(response.body) rescue { }
              expect(body['error']['code']).to eq('forbidden')
              expect(body['error']['message']).to eq('too_many_orders')
            end

          end

        end

      end

      describe 'as a staff member' do

        describe 'owning the restaurant' do

          describe 'without an existing order' do

            let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :restaurant_id => 1, :table_number => '3'
            end

            it 'should respond with a HTTP 201 status code' do
              expect(response).to be_success
              expect(response.status).to eq(201)
            end

            it 'should add the table number' do
              body = JSON.parse(response.body) rescue { }
              expect(body['order']['table_number']).to eq('3')
            end

          end

          describe 'with an existing order' do

            let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :restaurant_id => 1
            end

            it 'should respond with a HTTP 201 status code' do
              expect(response).to be_success
              expect(response.status).to eq(201)
            end

          end

          describe 'with more than one existing order' do

            let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :restaurant_id => 1
            end

            it 'should respond with a HTTP 201 status code' do
              expect(response).to be_success
              expect(response.status).to eq(201)
            end

          end

        end

        describe 'not owning the restaurant' do

          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          it 'should respond with a HTTP 403 status code' do
            post :create, :restaurant_id => 1
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end

          it 'should return a forbidden error message' do
            post :create, :restaurant_id => 1
            body = JSON.parse(response.body) rescue { }
            expect(body['error']['code']).to eq('forbidden')
            expect(body['error']['message']).to eq('different_restaurant')
          end

        end

      end

    end

    describe 'on missing restaurant' do

      before :each do
        post :create, :restaurant_id => 9999
      end

      describe 'as an owner' do

        let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope }

        it 'should respond with a HTTP 404 status code' do
          expect(response).to be_not_found
          expect(response.status).to eq(404)
        end

      end

    end

  end

end

