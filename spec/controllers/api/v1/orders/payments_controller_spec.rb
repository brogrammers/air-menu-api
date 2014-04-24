require 'spec_helper'

describe Api::V1::Orders::PaymentsController do
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
           :credit_cards

  before :each do
    controller.stub(:doorkeeper_token) { token }
    request.accept = 'application/json'
  end

  let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
  let(:admin_scope) { Doorkeeper::OAuth::Scopes.from_array ['admin'] }
  let(:owner_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
  let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['create_payments'] }

  describe 'POST #create' do

    describe 'on existing order' do

      describe 'as a user' do

        describe 'owning the order' do
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

          describe 'with a valid credit card' do

            before :each do
              post :create, :order_id => 10, :credit_card_id => 1
            end

            it 'should respond with a HTTP 201 status code' do
              expect(response).to be_success
              expect(response.status).to eq(201)
            end

          end

          describe 'with a invalid credit card' do

            before :each do
              post :create, :order_id => 10, :credit_card_id => 2
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

            it 'should return a model not found error message' do
              body = JSON.parse(response.body) rescue { }
              expect(body['error']['code']).to eq('model_not_found')
              expect(body['error']['model']).to eq('CreditCard')
            end

          end

        end

        describe 'now owning the order' do
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :order_id => 10, :credit_card_id => 1
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

      describe 'as a staff member' do

        describe 'owning the order' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :order_id => 10
          end

          it 'should respond with a HTTP 201 status code' do
            expect(response).to be_success
            expect(response.status).to eq(201)
          end

        end

        describe 'not owning the order' do
          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :order_id => 10
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

end