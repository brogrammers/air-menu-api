require 'spec_helper'

describe Api::V1::MenuSectionsController do
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
        get :index
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

    describe 'on existing menu section' do

      describe 'as a user' do

        let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        describe 'on an active menu section' do

          before :each do
            get :show, :id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'on an inactive menu section' do

          before :each do
            get :show, :id => 2
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

        end

      end

      describe 'as the owner' do

        let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
        let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

        describe 'on an active menu sestion' do

          before :each do
            get :show, :id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'on an inactive menu section' do

          before :each do
            get :show, :id => 2
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

      end

      describe 'as an owner' do

        let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
        let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

        describe 'on an active menu section' do

          before :each do
            get :show, :id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'on an inactive menu section' do

          before :each do
            get :show, :id => 2
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

        end

      end

      describe 'as a staff member' do

        describe 'owning the menu section' do

          describe 'on an active menu section' do
            let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            before :each do
              get :show, :id => 1
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

          end

          describe 'on an inactive menu section' do
            let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            before :each do
              get :show, :id => 2
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

          end

        end

        describe 'not owning the menu section' do

          describe 'on an active menu section' do
            let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            before :each do
              get :show, :id => 1
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

          end

          describe 'on an inactive menu section' do
            let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            before :each do
              get :show, :id => 2
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

          end

        end

      end

    end

    describe 'on missing menu section' do

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
        expect(body['error']['model']).to eq('MenuSection')
      end

    end

  end

  describe 'PUT #update' do

    describe 'on existing menu section' do

      describe 'as an owner' do
        let(:owner_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }

        describe 'owning the menu section' do
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          describe 'on an active menu section' do

            before :each do
              put :update, :id => 1, :name => 'new name', :description => 'new description', :staff_kind_id => 1
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'should changed the menu section attributes' do
              body = JSON.parse(response.body) rescue { }
              expect(body['menu_section']['name']).to eq('new name')
              expect(body['menu_section']['description']).to eq('new description')
              expect(body['menu_section']['staff_kind'].class == Hash).to be_true
            end

          end

          describe 'on an active menu section' do

            before :each do
              put :update, :id => 2, :name => 'new name', :description => 'new description', :staff_kind_id => 1
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'should changed the menu section attributes' do
              body = JSON.parse(response.body) rescue { }
              expect(body['menu_section']['name']).to eq('new name')
              expect(body['menu_section']['description']).to eq('new description')
              expect(body['menu_section']['staff_kind'].class == Hash).to be_true
            end

          end

        end

        describe 'not owning the menu section' do
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 1, :name => 'new name', :description => 'new description', :staff_kind_id => 1
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

          it 'should changed the menu section attributes' do
            body = JSON.parse(response.body) rescue { }
            expect(body['error']['code']).to eq('model_not_found')
            expect(body['error']['model']).to eq('MenuSection')
          end

        end

      end

      describe 'as a staff member' do
        let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['update_menus'] }

        describe 'owning the menu section' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          describe 'on an active menu section' do

            before :each do
              put :update, :id => 1, :name => 'new name', :description => 'new description', :staff_kind_id => 1
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'should changed the menu section attributes' do
              body = JSON.parse(response.body) rescue { }
              expect(body['menu_section']['name']).to eq('new name')
              expect(body['menu_section']['description']).to eq('new description')
              expect(body['menu_section']['staff_kind'].class == Hash).to be_true
            end

          end

          describe 'on an active menu section' do

            before :each do
              put :update, :id => 2, :name => 'new name', :description => 'new description', :staff_kind_id => 1
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'should changed the menu section attributes' do
              body = JSON.parse(response.body) rescue { }
              expect(body['menu_section']['name']).to eq('new name')
              expect(body['menu_section']['description']).to eq('new description')
              expect(body['menu_section']['staff_kind'].class == Hash).to be_true
            end

          end

        end

        describe 'not owning the menu section' do
          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 1, :name => 'new name', :description => 'new description', :staff_kind_id => 1
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

          it 'should changed the menu section attributes' do
            body = JSON.parse(response.body) rescue { }
            expect(body['error']['code']).to eq('model_not_found')
            expect(body['error']['model']).to eq('MenuSection')
          end

        end

      end

    end

  end

  describe 'DELETE #destroy' do

    describe 'on existing menu section' do

      describe 'as an owner' do
        let(:owner_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }

        describe 'owning the menu section' do
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          describe 'on an active menu section' do

            before :each do
              delete :destroy, :id => 1
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'should delete the menu section' do
              body = JSON.parse(response.body) rescue { }
              expect { MenuSection.find body['menu_section']['id'] }.to raise_error
            end

          end

          describe 'on an inactive menu section' do

            before :each do
              delete :destroy, :id => 2
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'should delete the menu section' do
              body = JSON.parse(response.body) rescue { }
              expect { MenuSection.find body['menu_section']['id'] }.to raise_error
            end

          end

        end

        describe 'not owning the menu section' do
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 1
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

          it 'should changed the menu section attributes' do
            body = JSON.parse(response.body) rescue { }
            expect(body['error']['code']).to eq('model_not_found')
            expect(body['error']['model']).to eq('MenuSection')
          end

        end

      end

      describe 'as a staff member' do
        let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['delete_menus'] }

        describe 'owning the menu section' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          describe 'on an active menu section' do

            before :each do
              delete :destroy, :id => 1
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'should delete the menu section' do
              body = JSON.parse(response.body) rescue { }
              expect { MenuSection.find body['menu_section']['id'] }.to raise_error
            end

          end

          describe 'on an inactive menu section' do

            before :each do
              delete :destroy, :id => 2
            end

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end

            it 'should delete the menu section' do
              body = JSON.parse(response.body) rescue { }
              expect { MenuSection.find body['menu_section']['id'] }.to raise_error
            end

          end

        end

        describe 'not owning the menu section' do
          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 2
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

          it 'should changed the menu section attributes' do
            body = JSON.parse(response.body) rescue { }
            expect(body['error']['code']).to eq('model_not_found')
            expect(body['error']['model']).to eq('MenuSection')
          end

        end

      end

    end

  end
end