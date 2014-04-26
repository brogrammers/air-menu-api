require 'spec_helper'

describe Api::V1::Restaurants::ReviewsController do
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
           :reviews

  before :each do
    controller.stub(:doorkeeper_token) { token }
    request.accept = 'application/json'
  end

  let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
  let(:admin_scope) { Doorkeeper::OAuth::Scopes.from_array ['admin'] }
  let(:owner_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
  let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array [] }
  let(:review_parameters) { {:restaurant_id => 1, :subject => 'subject', :message => 'message', :rating => 4} }

  describe 'GET #index' do

    describe 'on existing restaurant' do

      describe 'as a user' do
        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        before :each do
          get :index, :restaurant_id => 1
        end

        it 'should respond with a HTTP 200 status code' do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

      end

      describe 'as an owner' do
        let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

        before :each do
          get :index, :restaurant_id => 1
        end

        it 'should respond with a HTTP 200 status code' do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

      end

      describe 'as a staff member' do
        let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

        before :each do
          get :index, :restaurant_id => 1
        end

        it 'should respond with a HTTP 403 status code' do
          expect(response).to be_forbidden
          expect(response.status).to eq(403)
        end

      end

    end

  end

  describe 'POST #create' do

    describe 'on existing restaurant' do

      describe 'as a user' do

        describe 'with existing review' do
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, review_parameters
          end

          it 'should respond with a HTTP 201 status code' do
            expect(response).to be_success
            expect(response.status).to eq(201)
          end

        end

        describe 'without existing review' do
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, review_parameters
          end

          it 'should respond with a HTTP 403 status code' do
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end

        end

      end

      describe 'as an owner' do
        let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

        before :each do
          post :create, review_parameters
        end

        it 'should respond with a HTTP 201 status code' do
          expect(response).to be_success
          expect(response.status).to eq(201)
        end

        it 'should add a review with proper attributes' do
          body = JSON.parse(response.body) rescue { }
          expect(body['review']['subject']).to eq('subject')
          expect(body['review']['message']).to eq('message')
          expect(body['review']['rating']).to eq(4)
        end

      end

      describe 'as a staff member' do
        let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

        before :each do
          post :create, review_parameters
        end

        it 'should respond with a HTTP 403 status code' do
          expect(response).to be_forbidden
          expect(response.status).to eq(403)
        end

      end

    end

  end

end
