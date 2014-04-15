require 'spec_helper'

describe Api::V1::GroupsController do
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
           :groups

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

    describe 'on existing group' do

      describe 'as a user' do

        let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        before :each do
          get :show, :id => 1
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

        describe 'owning the group' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end


          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the group' do
          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
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

        describe 'owning the group' do

          before :each do
            get :show, :id => 1
          end

          describe 'with correct scope' do
            let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['get_groups'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end
          end

          describe 'with missing scope' do
            let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array [] }
            let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            it 'should respond with a HTTP 403 status code' do
              expect(response).to be_forbidden
              expect(response.status).to eq(403)
            end
          end

        end

      end

    end

    describe 'on missing group' do

      describe 'as an owner' do

        let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
        let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

        it 'should respond with a HTTP 404 status code' do
          get :show, :id => 9999
          expect(response).to be_not_found
          expect(response.status).to eq(404)
        end

        it 'should return a model not found error message' do
          get :show, :id => 9999
          body = JSON.parse(response.body) rescue { }
          expect(body['error']['code']).to eq('model_not_found')
          expect(body['error']['model']).to eq('Group')
        end

      end

    end

  end

  describe 'PUT #update' do

    describe 'on existing group' do

      describe 'as a user' do

        let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

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

      describe 'as an owner' do

        describe 'owning the group' do

          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 1, :name => 'new group name'
          end


          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

          it 'should change the group name' do
            body = JSON.parse(response.body) rescue { }
            expect(body['group']['name']).to eq('new group name')
          end

        end

        describe 'not owning the group' do
          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
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

      describe 'as a staff member' do

        describe 'owning the group' do

          before :each do
            put :update, :id => 1
          end

          describe 'with correct scope' do
            let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['update_groups'] }
            let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            it 'should respond with a HTTP 200 status code' do
              expect(response).to be_success
              expect(response.status).to eq(200)
            end
          end

          describe 'with missing scope' do
            let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array [] }
            let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

            it 'should respond with a HTTP 403 status code' do
              expect(response).to be_forbidden
              expect(response.status).to eq(403)
            end
          end

        end

      end

    end

    describe 'on missing group' do

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
          expect(body['error']['model']).to eq('Group')
        end

      end

    end

  end

end