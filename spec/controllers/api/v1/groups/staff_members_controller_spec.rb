require 'spec_helper'

describe Api::V1::Groups::StaffMembersController do
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

  let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
  let(:admin_scope) { Doorkeeper::OAuth::Scopes.from_array ['admin'] }
  let(:owner_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
  let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['get_groups', 'create_groups'] }

  describe 'GET #index' do

    describe 'on existing group' do

      describe 'as a user' do

        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        before :each do
          get :index, :group_id => 1
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
          get :index, :group_id => 1
        end

        describe 'owning the group' do

          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the group' do

          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

          it 'should return a forbidden error message' do
            body = JSON.parse(response.body) rescue { }
            expect(body['error']['code']).to eq('model_not_found')
            expect(body['error']['model']).to eq('Group')
          end

        end

      end

      describe 'as an owner' do

        before :each do
          get :index, :group_id => 1
        end

        describe 'owning the group' do

          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the group' do

          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

          it 'should return a forbidden error message' do
            body = JSON.parse(response.body) rescue { }
            expect(body['error']['code']).to eq('model_not_found')
            expect(body['error']['model']).to eq('Group')
          end

        end

      end

    end

    describe 'on missing group' do

      before :each do
        get :index, :group_id => 9999
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

  describe 'POST #create' do

    describe 'on existing group' do

      describe 'as a user' do

        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        before :each do
          post :create, :group_id => 1, :staff_member_id => 1
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

          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          describe 'with existing staff member' do

            before :each do
              post :create, :group_id => 1, :staff_member_id => 1
            end

            it 'should respond with a HTTP 201 status code' do
              expect(response).to be_success
              expect(response.status).to eq(201)
            end

            it 'should add a staff member to the group' do
              body = JSON.parse(response.body) rescue { }
              puts StaffMember.find(body['staff_member']['id'])
              expect(StaffMember.find(body['staff_member']['id']).group_id).to eq(1)
            end

          end

          describe 'with missing staff member' do

            before :each do
              post :create, :group_id => 1, :staff_member_id => 9999
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

            it 'should return a forbidden error message' do
              body = JSON.parse(response.body) rescue { }
              expect(body['error']['code']).to eq('model_not_found')
              expect(body['error']['model']).to eq('StaffMember')
            end

          end

        end

        describe 'not owning the group' do

          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

          describe 'with existing staff member' do

            before :each do
              post :create, :group_id => 1, :staff_member_id => 1
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

          end

        end

      end

      describe 'as a staff member' do

        describe 'owning the group' do

          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          describe 'with existing staff member' do

            before :each do
              post :create, :group_id => 1, :staff_member_id => 1
            end

            it 'should respond with a HTTP 201 status code' do
              expect(response).to be_success
              expect(response.status).to eq(201)
            end

            it 'should add a staff member to the group' do
              body = JSON.parse(response.body) rescue { }
              expect(StaffMember.find(body['staff_member']['id']).group_id).to eq(1)
            end

          end

          describe 'with missing staff member' do

            before :each do
              post :create, :group_id => 1, :staff_member_id => 9999
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

            it 'should return a forbidden error message' do
              body = JSON.parse(response.body) rescue { }
              expect(body['error']['code']).to eq('model_not_found')
              expect(body['error']['model']).to eq('StaffMember')
            end

          end

        end

        describe 'not owning the group' do

          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          describe 'with existing staff member' do

            before :each do
              post :create, :group_id => 1, :staff_member_id => 1
            end

            it 'should respond with a HTTP 404 status code' do
              expect(response).to be_not_found
              expect(response.status).to eq(404)
            end

          end

        end

      end

    end

    describe 'on missing group' do

      before :each do
        post :create, :group_id => 9999
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