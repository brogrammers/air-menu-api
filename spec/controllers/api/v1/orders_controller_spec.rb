require 'spec_helper'

describe Api::V1::OrdersController do
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

    describe 'on existing order' do

      describe 'as a user' do

        describe 'owning the order' do

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

        describe 'not owning the order' do
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

        describe 'owning the order' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end


          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the order' do
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

      describe 'as a staff member' do

        describe 'owning the order' do

          let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['get_orders'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end


          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the order' do
          let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['get_orders'] }
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

    describe 'on missing order' do

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
        expect(body['error']['model']).to eq('Order')
      end

    end

  end

  describe 'PUT #update' do

    describe 'on existing order' do

      describe 'as a user' do

        describe 'owning the order' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

            describe 'when order is new' do

              ['open', 'cancelled'].each do |state|

                describe "and set to #{state}" do

                  it 'should respond with a HTTP 200 status code' do
                    put :update, :id => 1, :state => state
                    expect(response.status).to eq(200)
                  end

                  it 'should return a conflict error message' do
                    put :update, :id => 1, :state => state
                    body = JSON.parse(response.body) rescue { }
                    expect(body['order']['state']).to eq(state)
                  end

                end

              end

              describe 'and set to open' do

                before :each do
                  put :update, :id => 7, :state => 'open'
                end

                it 'should assign the order to a staff member' do
                  body = JSON.parse(response.body) rescue { }
                  order = Order.find body['order']['id']
                  expect(order.staff_member).not_to be_false
                end

                it 'should assign the order items to staff members' do
                  body = JSON.parse(response.body) rescue { }
                  order = Order.find body['order']['id']
                  order.order_items.each do |order_item|
                    expect(order_item.staff_member).not_to be_false
                  end
                end

              end

            end

          end

        describe 'not owning the order' do
          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 1
          end


          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end
        end

      end

      describe 'as an owner' do

        describe 'owning the order' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

          describe 'when order is open' do

            ['cancelled'].each do |state|

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
                  expect(body['order']['state']).to eq(state)
                end

              end

            end

          end

        end

        describe 'not owning the order' do
          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
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

    end

    describe 'on missing order' do

      let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 404 status code' do
        put :update, :id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

      it 'should return a model not found error message' do
        put :update, :id => 9999
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('model_not_found')
        expect(body['error']['model']).to eq('Order')
      end

    end

  end

end