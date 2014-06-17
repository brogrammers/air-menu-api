require 'spec_helper'

describe Api::V1::OpeningHoursController do
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
           :opening_hours

  before :each do
    controller.stub(:doorkeeper_token) { token }
    request.accept = 'application/json'
  end

  let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
  let(:admin_scope) { Doorkeeper::OAuth::Scopes.from_array ['admin'] }
  let(:owner_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
  let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['get_opening_hours', 'update_opening_hours', 'delete_opening_hours'] }
  let(:opening_hour_parameters) { {} }

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

    describe 'on existing opening hour' do

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

        describe 'owning the opening hour' do
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the staff member' do
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end
        end

      end

      describe 'as a staff member' do

        describe 'owning the staff member' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the staff member' do
          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end
        end

      end

    end

    describe 'on missing opening hour' do
      let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

      it 'should respond with a HTTP 404 status code' do
        get :show, :id => 9999
        expect(response).to be_not_found
        expect(response.status).to eq(404)
      end

    end

  end

  describe 'PUT #update' do

    describe 'on existing opening hour' do

      describe 'as a user' do
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

        describe 'owning the opening hour' do
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 1, :day => 'sunday', :start => Time.now.iso8601, :end => '1.0'
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

          it 'should change the opening hour attributes' do
            body = JSON.parse(response.body) rescue { }
            expect(body['opening_hour']['day']).to eq('sunday')
          end

        end

        describe 'not owning the opening hour' do
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

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

        describe 'owning the opening hour' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 1, :day => 'sunday', :start => Time.now.iso8601, :end => '1.0'
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

          it 'should change the opening hour attributes' do
            body = JSON.parse(response.body) rescue { }
            expect(body['opening_hour']['day']).to eq('sunday')
          end

        end

        describe 'not owning the opening hour' do
          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

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

    describe 'on existing opening hour' do

      describe 'as a user' do
        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        before :each do
          delete :destroy, :id => 1
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

        describe 'owning the opening hour' do
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

        end

        describe 'not owning the opening hour' do
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 1
          end

          it 'should respond with a HTTP 404 status code' do
            expect(response).to be_not_found
            expect(response.status).to eq(404)
          end
        end

      end

      describe 'as a staff member' do

        describe 'owning the opening hour' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

          it 'should delete the opening hour' do
            expect { OpeningHour.find(1) }.to raise_error
          end

        end

        describe 'not owning the opening hour' do
          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

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