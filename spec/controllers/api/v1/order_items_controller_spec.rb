require 'spec_helper'

describe Api::V1::OrderItemsController do
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
           :staff_members,
           :order_items,
           :devices

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

    describe 'on existing order item' do

      describe 'as a user' do

        describe 'owning the order item' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the order item' do
          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end
        end

      end

      describe 'as an owner' do

        describe 'owning the order item' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end


          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the order item' do
          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end


          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end
        end

      end

      describe 'as a staff member' do

        describe 'owning the order item' do

          let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['get_current_orders'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 7, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the order item' do
          let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['get_current_orders'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end
        end

      end

    end

    describe 'on missing order item' do

      let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 404 status code' do
        get :show, :id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

      it 'should return a model not found error message' do
        get :show, :id => 9999
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('model_not_found')
        expect(body['error']['model']).to eq('OrderItem')
      end

    end

  end

  describe 'PUT #update' do

    describe 'on existing order item' do

      describe 'as a user' do

        describe 'owning the order item' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

          [
              {:state => 'approved', :id => 2},
              {:state => 'declined', :id => 3},
              {:state => 'start_prepare', :id => 4},
              {:state => 'end_prepare', :id => 5},
              {:state => 'served', :id => 6},
          ].each do |value|

            describe "when order item is #{value[:state]}" do

              ['approved', 'declined', 'start_prepare', 'end_prepare', 'served'].each do |state|

                describe "and set to #{state}" do

                  it 'should respond with a HTTP 403 status code' do
                    put :update, :id => value[:id], :state => state
                    expect(response.status).to eq(403)
                  end

                  it 'should return a forbidden error message' do
                    put :update, :id => value[:id], :state => state
                    body = JSON.parse(response.body) rescue { }
                    expect(body['error']['code']).to eq('invalid_scope')
                  end

                end

              end

            end

          end

        end

        describe 'not owning the order item' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 1
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

      describe 'as an owner' do

        describe 'owning the order item' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

          describe 'when order item is new' do

            ['approved', 'declined'].each do |state|

              describe "and set to #{state}" do

                before :each do
                  put :update, :id => 1, :state => state
                end

                it 'should respond with a HTTP 200 status code' do
                  expect(response).to be_success
                  expect(response.status).to eq(200)
                end

                it "should change to #{state}" do
                  body = JSON.parse(response.body) rescue { }
                  expect(body['order_item']['state']).to eq(state)
                end

              end

            end

            ['start_prepare', 'end_prepare', 'served'].each do |state|

              describe "and set to #{state}" do

                it 'should respond with a HTTP 409 status code' do
                  put :update, :id => 1, :state => state
                  expect(response.status).to eq(409)
                end

                it 'should return a conflict error message' do
                  put :update, :id => 1, :state => state
                  body = JSON.parse(response.body) rescue { }
                  expect(body['error']['code']).to eq('conflict')
                  expect(body['error']['message']).to eq('order_item_error')
                end

              end

            end

            describe 'when it\'s the last order item to change state' do

              it 'should change the order to approved' do
                put :update, :id => 8, :state => 'approved'
                body = JSON.parse(response.body) rescue { }
                id = body['order_item']['order']['id']
                expect(Order.find(id).state).to eq(:approved)
              end

              it 'should keep the order in open state' do
                put :update, :id => 8, :state => 'declined'
                body = JSON.parse(response.body) rescue { }
                id = body['order_item']['order']['id']
                expect(Order.find(id).state).to eq(:open)
              end

            end

          end

          describe 'when order item is approved' do

            ['start_prepare'].each do |state|

              describe "and set to #{state}" do

                before :each do
                  put :update, :id => 2, :state => state
                end

                it 'should respond with a HTTP 200 status code' do
                  expect(response).to be_success
                  expect(response.status).to eq(200)
                end

                it "should change to #{state}" do
                  body = JSON.parse(response.body) rescue { }
                  expect(body['order_item']['state']).to eq(state)
                end

              end

            end

            ['approved', 'declined', 'end_prepare', 'served'].each do |state|

              describe "and set to #{state}" do

                it 'should respond with a HTTP 409 status code' do
                  put :update, :id => 2, :state => state
                  expect(response.status).to eq(409)
                end

                it 'should return a conflict error message' do
                  put :update, :id => 2, :state => state
                  body = JSON.parse(response.body) rescue { }
                  expect(body['error']['code']).to eq('conflict')
                  expect(body['error']['message']).to eq('order_item_error')
                end

              end

            end

          end

          describe 'when order item is declined' do

            ['approved', 'declined', 'start_prepare', 'end_prepare', 'served'].each do |state|

              describe "and set to #{state}" do

                it 'should respond with a HTTP 409 status code' do
                  put :update, :id => 3, :state => state
                  expect(response.status).to eq(409)
                end

                it "should change to #{state}" do
                  put :update, :id => 3, :state => state
                  body = JSON.parse(response.body) rescue { }
                  expect(body['error']['code']).to eq('conflict')
                  expect(body['error']['message']).to eq('order_item_error')
                end

              end

            end

          end

          describe 'when order item is in preparation' do

            ['end_prepare'].each do |state|

              describe "and set to #{state}" do

                before :each do
                  put :update, :id => 4, :state => state
                end

                it 'should respond with a HTTP 200 status code' do
                  expect(response).to be_success
                  expect(response.status).to eq(200)
                end

                it "should change to #{state}" do
                  body = JSON.parse(response.body) rescue { }
                  expect(body['order_item']['state']).to eq(state)
                end

              end

            end

            ['approved', 'declined', 'start_prepare', 'served'].each do |state|

              describe "and set to #{state}" do

                it 'should respond with a HTTP 409 status code' do
                  put :update, :id => 4, :state => state
                  expect(response.status).to eq(409)
                end

                it 'should return a conflict error message' do
                  put :update, :id => 4, :state => state
                  body = JSON.parse(response.body) rescue { }
                  expect(body['error']['code']).to eq('conflict')
                  expect(body['error']['message']).to eq('order_item_error')
                end

              end

            end

          end

          describe 'when order item finished preparation' do

            ['served'].each do |state|

              describe "and set to #{state}" do

                before :each do
                  put :update, :id => 5, :state => state
                end

                it 'should respond with a HTTP 200 status code' do
                  expect(response).to be_success
                  expect(response.status).to eq(200)
                end

                it "should change to #{state}" do
                  body = JSON.parse(response.body) rescue { }
                  expect(body['order_item']['state']).to eq(state)
                end

              end

            end

            ['approved', 'declined', 'start_prepare', 'end_prepare'].each do |state|

              describe "and set to #{state}" do

                it 'should respond with a HTTP 409 status code' do
                  put :update, :id => 5, :state => state
                  expect(response.status).to eq(409)
                end

                it 'should return a conflict error message' do
                  put :update, :id => 5, :state => state
                  body = JSON.parse(response.body) rescue { }
                  expect(body['error']['code']).to eq('conflict')
                  expect(body['error']['message']).to eq('order_item_error')
                end

              end

            end

            describe 'when it\'s the last order item to change state' do

              it 'should change the order to served' do
                put :update, :id => 10, :state => 'served'
                body = JSON.parse(response.body) rescue { }
                id = body['order_item']['order']['id']
                expect(Order.find(id).state).to eq(:served)
              end

            end

          end

          describe 'when order item served' do

            ['approved', 'declined', 'start_prepare', 'end_prepare', 'served'].each do |state|

              describe "and set to #{state}" do

                it 'should respond with a HTTP 409 status code' do
                  put :update, :id => 6, :state => state
                  expect(response.status).to eq(409)
                end

                it 'should return a conflict error message' do
                  put :update, :id => 6, :state => state
                  body = JSON.parse(response.body) rescue { }
                  expect(body['error']['code']).to eq('conflict')
                  expect(body['error']['message']).to eq('order_item_error')
                end

              end

            end

          end

        end

        describe 'not owning the order item' do
          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            put :show, :id => 1
          end


          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end
        end

      end

      describe 'as a staff member' do

        describe 'owning the order item' do

          let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['update_orders'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 7, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          describe 'when order item is new' do

            ['approved', 'declined'].each do |state|

              describe "and set to #{state}" do

                before :each do
                  put :update, :id => 1, :state => state
                end

                it 'should respond with a HTTP 200 status code' do
                  expect(response).to be_success
                  expect(response.status).to eq(200)
                end

                it "should change to #{state}" do
                  body = JSON.parse(response.body) rescue { }
                  expect(body['order_item']['state']).to eq(state)
                end

              end

            end

            ['start_prepare', 'end_prepare', 'served'].each do |state|

              describe "and set to #{state}" do

                it 'should respond with a HTTP 409 status code' do
                  put :update, :id => 1, :state => state
                  expect(response.status).to eq(409)
                end

                it 'should return a conflict error message' do
                  put :update, :id => 1, :state => state
                  body = JSON.parse(response.body) rescue { }
                  expect(body['error']['code']).to eq('conflict')
                  expect(body['error']['message']).to eq('order_item_error')
                end

              end

            end

            describe 'when it\'s the last order item to change state' do

              it 'should change the order to approved' do
                put :update, :id => 8, :state => 'approved'
                body = JSON.parse(response.body) rescue { }
                id = body['order_item']['order']['id']
                expect(Order.find(id).state).to eq(:approved)
              end

              it 'should keep the order in open state' do
                put :update, :id => 8, :state => 'declined'
                body = JSON.parse(response.body) rescue { }
                id = body['order_item']['order']['id']
                expect(Order.find(id).state).to eq(:open)
              end

            end

          end

          describe 'when order item is approved' do

            ['start_prepare'].each do |state|

              describe "and set to #{state}" do

                before :each do
                  put :update, :id => 2, :state => state
                end

                it 'should respond with a HTTP 200 status code' do
                  expect(response).to be_success
                  expect(response.status).to eq(200)
                end

                it "should change to #{state}" do
                  body = JSON.parse(response.body) rescue { }
                  expect(body['order_item']['state']).to eq(state)
                end

              end

            end

            ['approved', 'declined', 'end_prepare', 'served'].each do |state|

              describe "and set to #{state}" do

                it 'should respond with a HTTP 409 status code' do
                  put :update, :id => 2, :state => state
                  expect(response.status).to eq(409)
                end

                it 'should return a conflict error message' do
                  put :update, :id => 2, :state => state
                  body = JSON.parse(response.body) rescue { }
                  expect(body['error']['code']).to eq('conflict')
                  expect(body['error']['message']).to eq('order_item_error')
                end

              end

            end

          end

          describe 'when order item is declined' do

            ['approved', 'declined', 'start_prepare', 'end_prepare', 'served'].each do |state|

              describe "and set to #{state}" do

                it 'should respond with a HTTP 409 status code' do
                  put :update, :id => 3, :state => state
                  expect(response.status).to eq(409)
                end

                it "should change to #{state}" do
                  put :update, :id => 3, :state => state
                  body = JSON.parse(response.body) rescue { }
                  expect(body['error']['code']).to eq('conflict')
                  expect(body['error']['message']).to eq('order_item_error')
                end

              end

            end

          end

          describe 'when order item is in preparation' do

            ['end_prepare'].each do |state|

              describe "and set to #{state}" do

                before :each do
                  put :update, :id => 4, :state => state
                end

                it 'should respond with a HTTP 200 status code' do
                  expect(response).to be_success
                  expect(response.status).to eq(200)
                end

                it "should change to #{state}" do
                  body = JSON.parse(response.body) rescue { }
                  expect(body['order_item']['state']).to eq(state)
                end

              end

            end

            ['approved', 'declined', 'start_prepare', 'served'].each do |state|

              describe "and set to #{state}" do

                it 'should respond with a HTTP 409 status code' do
                  put :update, :id => 4, :state => state
                  expect(response.status).to eq(409)
                end

                it 'should return a conflict error message' do
                  put :update, :id => 4, :state => state
                  body = JSON.parse(response.body) rescue { }
                  expect(body['error']['code']).to eq('conflict')
                  expect(body['error']['message']).to eq('order_item_error')
                end

              end

            end

          end

          describe 'when order item finished preparation' do

            ['served'].each do |state|

              describe "and set to #{state}" do

                before :each do
                  put :update, :id => 5, :state => state
                end

                it 'should respond with a HTTP 200 status code' do
                  expect(response).to be_success
                  expect(response.status).to eq(200)
                end

                it "should change to #{state}" do
                  body = JSON.parse(response.body) rescue { }
                  expect(body['order_item']['state']).to eq(state)
                end

              end

            end

            ['approved', 'declined', 'start_prepare', 'end_prepare'].each do |state|

              describe "and set to #{state}" do

                it 'should respond with a HTTP 409 status code' do
                  put :update, :id => 5, :state => state
                  expect(response.status).to eq(409)
                end

                it 'should return a conflict error message' do
                  put :update, :id => 5, :state => state
                  body = JSON.parse(response.body) rescue { }
                  expect(body['error']['code']).to eq('conflict')
                  expect(body['error']['message']).to eq('order_item_error')
                end

              end

            end

            describe 'when it\'s the last order item to change state' do

              it 'should change the order to served' do
                put :update, :id => 10, :state => 'served'
                body = JSON.parse(response.body) rescue { }
                id = body['order_item']['order']['id']
                expect(Order.find(id).state).to eq(:served)
              end

            end

          end

          describe 'when order item served' do

            ['approved', 'declined', 'start_prepare', 'end_prepare', 'served'].each do |state|

              describe "and set to #{state}" do

                it 'should respond with a HTTP 409 status code' do
                  put :update, :id => 6, :state => state
                  expect(response.status).to eq(409)
                end

                it 'should return a conflict error message' do
                  put :update, :id => 6, :state => state
                  body = JSON.parse(response.body) rescue { }
                  expect(body['error']['code']).to eq('conflict')
                  expect(body['error']['message']).to eq('order_item_error')
                end

              end

            end

          end

        end

        describe 'not owning the order item' do
          let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['update_orders'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            put :show, :id => 1
          end


          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end
        end

      end

    end

    describe 'on missing order item' do

      describe 'as an owner' do

        let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
        let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

        it 'should respond with a HTTP 404 status code' do
          put :update, :id => 9999
          expect(response).to be_not_found
          expect(response.status).to eq(404)
        end

        it 'should return a model not found error message' do
          put :update, :id => 9999
          body = JSON.parse(response.body) rescue { }
          expect(body['error']['code']).to eq('model_not_found')
          expect(body['error']['model']).to eq('OrderItem')
        end

      end

    end

  end

end