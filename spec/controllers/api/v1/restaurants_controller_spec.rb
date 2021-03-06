require 'spec_helper'

describe Api::V1::RestaurantsController do
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
           :devices

  before :each do
    controller.stub(:doorkeeper_token) { token }
    request.accept = 'application/json'
  end

  describe 'GET #index' do

    describe 'with admin scope' do

      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => ['admin'] }

      it 'should respond with a HTTP 200 status code' do
        get :index, :latitude => 59.99999, :longitude => 59.99999, :offset => 1000
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

    describe 'on existing restaurant' do

      describe 'as a user' do

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

      describe 'as an owner' do

        describe 'owning the restaurant' do

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

        describe 'not owning the restaurant' do
          let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => user_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end


          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end
        end

      end

      describe 'as an owner' do

        describe 'owning the restaurant' do

          let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end


          it 'should respond with a HTTP 403 status code' do
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end

        end

        describe 'not owning the restaurant' do
          let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }
          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            get :show, :id => 1
          end


          it 'should respond with a HTTP 403 status code' do
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end
        end

      end

    end

    describe 'on missing restaurant' do

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
        expect(body['error']['model']).to eq('Restaurant')
      end

    end

  end

  describe 'PUT #update' do

    describe 'on existing restaurant' do

      describe 'as a user' do
        let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        it 'should respond with a HTTP 403 status code' do
          put :update, :id => 1
          expect(response).to be_forbidden
          expect(response.status).to eq(403)
        end

      end

      describe 'as an owner' do
        let(:owner_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }

        describe 'owning the restaurant' do
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 1, :name => 'new name', :description => 'new description', :address_1 => 'new a1', :address_2 => 'new a2', :city => 'new city', :county => 'new county', :state => 'new state', :country => 'new country', :latitude => 54.3452, :longitude => 4.2342
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

          it 'should change the correct attributes' do
            body = JSON.parse(response.body) rescue { }
            expect(body['restaurant']['name']).to eq('new name')
            expect(body['restaurant']['description']).to eq('new description')
          end

        end

        describe 'not owning the restaurant' do
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 1, :name => 'new name', :address_1 => 'new a1', :address_2 => 'new a2', :city => 'new city', :county => 'new county', :state => 'new state', :country => 'new country', :latitude => 54.3452, :longitude => 4.2342
          end

          it 'should respond with a HTTP 403 status code' do
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end

        end

      end

      describe 'as a staff member' do
        let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }

        describe 'owning the restaurant' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 1, :name => 'new name', :address_1 => 'new a1', :address_2 => 'new a2', :city => 'new city', :county => 'new county', :state => 'new state', :country => 'new country', :latitude => 54.3452, :longitude => 4.2342
          end

          it 'should respond with a HTTP 403 status code' do
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end

        end

        describe 'not owning the restaurant' do
          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            put :update, :id => 1, :name => 'new name', :address_1 => 'new a1', :address_2 => 'new a2', :city => 'new city', :county => 'new county', :state => 'new state', :country => 'new country', :latitude => 54.3452, :longitude => 4.2342
          end

          it 'should respond with a HTTP 403 status code' do
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end

        end

      end

    end

  end

  describe 'DELETE #destroy' do

    describe 'on existing restaurant' do

      describe 'as a user' do
        let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user'] }
        let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }

        it 'should respond with a HTTP 403 status code' do
          delete :destroy, :id => 1
          expect(response).to be_forbidden
          expect(response.status).to eq(403)
        end

      end

      describe 'as an owner' do
        let(:owner_scope) { Doorkeeper::OAuth::Scopes.from_array ['owner'] }

        describe 'owning the restaurant' do
          let(:token) { double :accessible? => true, :resource_owner_id => 2, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 1
          end

          it 'should respond with a HTTP 200 status code' do
            expect(response).to be_success
            expect(response.status).to eq(200)
          end

          it 'should delete the menus' do
            expect { Menu.find 1 }.to raise_error
          end

          it 'should delete the orders' do
            expect { Order.find 1 }.to raise_error
          end

          it 'should delete the staff kinds' do
            expect { StaffKind.find 1 }.to raise_error
          end

          it 'should delete the staff members' do
            expect { StaffMember.find 1 }.to raise_error
          end

          it 'should delete the groups' do
            expect { Group.find 1 }.to raise_error
          end

          it 'should delete the reviews' do
            expect { Review.find 1 }.to raise_error
          end

          it 'should delete the opening hours' do
            expect { OpeningHour.find 1 }.to raise_error
          end

          it 'should delete the webhooks' do
            expect { Webhook.find 1 }.to raise_error
          end

          it 'should delete the device' do
            expect { Device.find 3 }.to raise_error
          end

        end

        describe 'not owning the restaurant' do
          let(:token) { double :accessible? => true, :resource_owner_id => 3, :scopes => owner_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 1
          end

          it 'should respond with a HTTP 403 status code' do
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end

        end

      end

      describe 'as a staff member' do
        let(:staff_member_scope) { Doorkeeper::OAuth::Scopes.from_array ['basic'] }

        describe 'owning the restaurant' do
          let(:token) { double :accessible? => true, :resource_owner_id => 6, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 1
          end

          it 'should respond with a HTTP 403 status code' do
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end

        end

        describe 'not owning the restaurant' do
          let(:token) { double :accessible? => true, :resource_owner_id => 10, :scopes => staff_member_scope, :revoked? => false, :expired? => false }

          before :each do
            delete :destroy, :id => 1
          end

          it 'should respond with a HTTP 403 status code' do
            expect(response).to be_forbidden
            expect(response.status).to eq(403)
          end

        end

      end

    end

  end

end