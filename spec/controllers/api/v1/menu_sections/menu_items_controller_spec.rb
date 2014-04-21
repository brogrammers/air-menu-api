require 'spec_helper'

describe Api::V1::MenuSections::MenuItemsController do
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

    describe 'on existing menu section' do

      describe 'as a user' do

        describe 'on an active menu section' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope }

          it 'should respond with a HTTP 200 status code' do
            get :index, :menu_section_id => 1
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'on an inactive menu section' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope }

          it 'should respond with a HTTP 404 status code' do
            get :index, :menu_section_id => 2
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

        end

      end

      describe 'as an owner' do

        describe 'owning the menu section' do

          describe 'on an active menu section' do

            let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope }

            before :each do
              get :index, :menu_section_id => 1
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

          end

          describe 'on an inactive menu section' do

            let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope }

            before :each do
              get :index, :menu_section_id => 2
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

          end

        end

        describe 'not owning the menu section' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope }

          before :each do
            get :index, :menu_section_id => 2
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

      end

      describe 'as a staff member' do

        describe 'owning the menu section' do

          describe 'on an active menu section' do

            let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => user_scope, :revoked? => false, :expired? => false }

            before :each do
              get :index, :menu_section_id => 1
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

          end

          describe 'on an inactive menu section' do

            let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => user_scope, :revoked? => false, :expired? => false }

            before :each do
              get :index, :menu_section_id => 2
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

          end

        end

        describe 'not owning the menu section' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            get :index, :menu_section_id => 2
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

        end

      end

    end

    describe 'on missing menu section' do

      let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 404 status code' do
        get :index, :menu_section_id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

      it 'should return a model not found error message' do
        get :index, :menu_section_id => 9999
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('model_not_found')
        expect(body['error']['model']).to eq('MenuSection')
      end

    end

  end

  describe 'POST #create' do

    describe 'on existing menu section' do

      describe 'as a user' do

        describe 'on an active menu section' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :menu_section_id => 1, :name => 'name', :description => 'description', :price => '12.10', :currency => 'EUR'
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
            post :create, :menu_section_id => 2, :name => 'name', :description => 'description', :price => '12.10', :currency => 'EUR'
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

        describe 'owning the menu section' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :menu_section_id => 1, :name => 'name', :description => 'description', :price => '12.10', :currency => 'EUR'
          end

          it 'should respond with a HTTP 201 status code' do
            expect(response).to be_success
            expect(response.status).to eq(201)
          end

          it 'should create a new menu item object' do
            body = JSON.parse(response.body) rescue { }
            menu_item = MenuItem.find(body['menu_item']['id']) rescue nil
            expect(menu_item).not_to be_nil
          end

        end

        describe 'not owning the menu section' do

          describe 'on an active menu section' do

            let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :menu_section_id => 1, :name => 'name', :description => 'description', :price => '12.10', :currency => 'EUR'
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

          describe 'on an inactive menu section' do

            let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :menu_section_id => 2, :name => 'name', :description => 'description', :price => '12.10', :currency => 'EUR'
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

            it 'should return a model not found error message' do
              body = JSON.parse(response.body) rescue { }
              expect(body['error']['code']).to eq('model_not_found')
              expect(body['error']['model']).to eq('MenuSection')
            end

          end

        end

      end

      describe 'as a staff member' do

        describe 'owning the menu section' do

          let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['add_menus'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            post :create, :menu_section_id => 1, :name => 'name', :description => 'description', :price => '12.10', :currency => 'EUR'
          end

          it 'should respond with a HTTP 201 status code' do
            expect(response).to be_success
            expect(response.status).to eq(201)
          end

          it 'should create a new menu item object' do
            body = JSON.parse(response.body) rescue { }
            menu_item = MenuItem.find(body['menu_item']['id']) rescue nil
            expect(menu_item).not_to be_nil
          end

        end

        describe 'not owning the menu section' do

          describe 'on an active menu section' do

            let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['add_menus'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :menu_section_id => 1, :name => 'name', :description => 'description', :price => '12.10', :currency => 'EUR'
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

          describe 'on an inactive menu section' do

            let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['add_menus'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            before :each do
              post :create, :menu_section_id => 2, :name => 'name', :description => 'description', :price => '12.10', :currency => 'EUR'
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

            it 'should return a model not found error message' do
              body = JSON.parse(response.body) rescue { }
              expect(body['error']['code']).to eq('model_not_found')
              expect(body['error']['model']).to eq('MenuSection')
            end

          end

        end

      end

    end

    describe 'on missing menu section' do

      let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
      let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 404 status code' do
        post :create, :menu_section_id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

      it 'should return a model not found error message' do
        get :create, :menu_section_id => 9999
        body = JSON.parse(response.body) rescue { }
        expect(body['error']['code']).to eq('model_not_found')
        expect(body['error']['model']).to eq('MenuSection')
      end

    end

  end

end