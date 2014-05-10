require 'spec_helper'

describe Api::V1::Me::CreditCardsController do
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

  let(:user_scope) { Doorkeeper::OAuth::Scopes.from_array ['user', 'owner'] }
  let(:none_scope) { Doorkeeper::OAuth::Scopes.from_array [] }
  let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => user_scope, :revoked? => false, :expired? => false }
  let(:credit_card_parameters) { {:number => '4319445320747508', :card_type => 'VISA', :month => '01', :year => '18', :cvc => '445'} }

  describe 'GET #index' do

    before :each do
      get :index
    end

    describe 'with user and owner scope' do

      it 'should respond with a HTTP 200 status code' do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

    end

    describe 'without user and owner scope' do

      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => none_scope, :revoked? => false, :expired? => false }

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

  describe 'POST #create' do

    before :each do
      post :create, credit_card_parameters
    end

    describe 'with user and owner scope' do

      it 'should respond with a HTTP 201 status code' do
        expect(response).to be_success
        expect(response.status).to eq(201)
      end

      it 'should create a credit card object' do
        body = JSON.parse(response.body) rescue { }
        id = body['credit_card']['id']
        expect { CreditCard.find(id) }.not_to raise_error
      end

      it 'should save all the attributes' do
        body = JSON.parse(response.body) rescue { }
        device = CreditCard.find body['credit_card']['id']
        expect(device.number).to eq(credit_card_parameters[:number])
        expect(device.card_type).to eq(credit_card_parameters[:card_type])
        expect(device.month).to eq(credit_card_parameters[:month])
        expect(device.year).to eq(credit_card_parameters[:year])
      end

    end

    describe 'without user and owner scope' do

      let(:token) { double :accessible? => true, :resource_owner_id => 1, :scopes => none_scope, :revoked? => false, :expired? => false }

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

end