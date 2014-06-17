require 'spec_helper'

describe Api::V1::DevicesController do
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
           :groups,
           :devices

  before :each do
    controller.stub(:doorkeeper_token) { token }
    request.accept = 'application/json'
  end

  let(:no_scope) { Doorkeeper::OAuth::Scopes.from_array [] }
  let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
  let(:admin_scope) { Doorkeeper::OAuth::Scopes.from_array ['admin'] }
  let(:owner_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }
  let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['get_devices', 'update_devices', 'delete_devices'] }

  describe 'GET #index' do

    describe 'with admin scope' do
      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => admin_scope }

      it 'should respond with a HTTP 200 status code' do
        get :index
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

    end

    describe 'without admin scope' do
      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => no_scope, :revoked? => false, :expired? => false }

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

    describe 'on existing device' do

      describe 'as a user' do
        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        before :each do
          get :show, :id => 1
        end

        it 'should respond with a HTTP 200 status code' do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

      end

      describe 'as an owner' do

        describe 'owning the device' do
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 2
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'owning the device' do
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

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

        describe 'owning the device' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 3
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'owning the device' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

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

  end

  describe 'PUT #update' do

    describe 'on existing device' do

      describe 'as a user' do
        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        before :each do
          put :update, :id => 1, :name => 'new name', :uuid => 'new uuid', :token => 'new token', :platform => 'ios'
        end

        it 'should respond with a HTTP 200 status code' do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it 'should change the device' do
          body = JSON.parse(response.body) rescue { }
          expect(body['device']['name']).to eq('new name')
          expect(body['device']['uuid']).to eq('new uuid')
          expect(body['device']['token']).to eq('new token')
          expect(body['device']['platform']).to eq('ios')
        end

      end

      describe 'as an owner' do

        describe 'owning the device' do
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 2, :name => 'new name', :uuid => 'new uuid', :token => 'new token', :platform => 'ios'
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

          it 'should change the device' do
            body = JSON.parse(response.body) rescue { }
            expect(body['device']['name']).to eq('new name')
            expect(body['device']['uuid']).to eq('new uuid')
            expect(body['device']['token']).to eq('new token')
            expect(body['device']['platform']).to eq('ios')
          end

        end

        describe 'not owning the device' do
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 2
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

        end

      end

      describe 'as a staff member' do

        describe 'owning the device' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 3, :name => 'new name', :uuid => 'new uuid', :token => 'new token', :platform => 'ios'
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

          it 'should change the device' do
            body = JSON.parse(response.body) rescue { }
            expect(body['device']['name']).to eq('new name')
            expect(body['device']['uuid']).to eq('new uuid')
            expect(body['device']['token']).to eq('new token')
            expect(body['device']['platform']).to eq('ios')
          end

        end

        describe 'owning the device' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 1
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

        end

      end

    end

  end

  describe 'DELETE #destroy' do

    describe 'on existing device' do

      describe 'as a user' do
        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        before :each do
          delete :destroy, :id => 1
        end

        it 'should respond with a HTTP 200 status code' do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it 'should delete the device' do
          body = JSON.parse(response.body) rescue { }
          expect { Device.find body['device']['id'] }.to raise_error
        end

      end

      describe 'as an owner' do

        describe 'owning the device' do
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 2
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

          it 'should delete the device' do
            body = JSON.parse(response.body) rescue { }
            expect { Device.find body['device']['id'] }.to raise_error
          end

        end

        describe 'not owning the device' do
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 2
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

        end

      end

      describe 'as a staff member' do

        describe 'owning the device' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 3
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

          it 'should delete the device' do
            body = JSON.parse(response.body) rescue { }
            expect { Device.find body['device']['id'] }.to raise_error
          end

          it 'should delete the device reference from the restaurant' do
            staff_member = StaffMember.find 3
            expect(staff_member.device_id).to be_nil
          end

        end

        describe 'owning the device' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 1
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end

        end

      end

    end

  end

end