require 'spec_helper'

describe Api::V1::Menus::MenuSectionsController do
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

    describe 'on existing menu' do

      describe 'as a user' do

        describe 'on an active menu' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope }

          it 'should respond with a HTTP 200 status code' do
            get :index, :menu_id => 1
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'on an inactive menu' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope }

          it 'should respond with a HTTP 404 status code' do
            get :index, :menu_id => 2
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

        end

      end

      describe 'as an owner' do

        describe 'owning the menu' do

          describe 'on an active menu' do

            let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope }

            before :each do
              get :index, :menu_id => 1
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

          end

          describe 'on an inactive menu' do

            let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope }

            before :each do
              get :index, :menu_id => 2
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

          end

        end

        describe 'not owning the menu' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope }

          before :each do
            get :index, :menu_id => 2
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

      end

    end

    describe 'on missing menu' do

      let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 404 status code' do
        get :index, :menu_id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

      it 'should return a model not found error message' do
        get :index, :menu_id => 9999
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('model_not_found')
        expect(body['error']['model']).to eq('Menu')
      end

    end

  end

  describe 'POST #create' do

    describe 'on existing menu' do

      describe 'as a user' do

        describe 'on an active menu' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :menu_id => 1, :name => 'name'
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

        describe 'on an inactive menu section' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :menu_id => 2, :name => 'name'
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

        describe 'owning the menu' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :menu_id => 1, :name => 'name', :description => 'description', :staff_kind_id => 1
          end

          it 'should respond with a HTTP 201 status code' do
            expect(response).to be_success
            expect(response.status).to eq(201)
          end

          it 'should create a new menu section object' do
            body = JSON.parse(response.body) rescue { }
            menu_section = MenuSection.find(body['menu_section']['id']) rescue nil
            expect(menu_section).not_to be_nil
          end

        end

        describe 'not owning the menu' do

          describe 'on an active menu' do

            let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :menu_id => 1, :name => 'name'
            end

            it 'should respond with a HTTP 403 status code' do
              expect(response).to be_forbidden
              expect(response.status).to eq(403)
            end

            it 'should return a model not found error message' do
              body = JSON.parse(response.body) rescue { }
              expect(body['error']['code']).to eq('forbidden')
              expect(body['error']['message']).to eq('ownership_failure')
            end

          end

          describe 'on an inactive menu' do

            let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :menu_id => 2, :name => 'name'
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

            it 'should return a model not found error message' do
              body = JSON.parse(response.body) rescue { }
              expect(body['error']['code']).to eq('model_not_found')
              expect(body['error']['model']).to eq('Menu')
            end

          end

        end

      end

    end

    describe 'on missing menu' do

      let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
      let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 404 status code' do
        post :create, :menu_id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

      it 'should return a model not found error message' do
        get :create, :menu_id => 9999
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('model_not_found')
        expect(body['error']['model']).to eq('Menu')
      end

    end

  end

end