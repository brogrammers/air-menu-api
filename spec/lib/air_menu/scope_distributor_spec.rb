require 'spec_helper'

describe AirMenu::ScopeDistributor do

  describe 'when scope parameter is empty' do

    let(:params) { {:scope => ''} }
    let(:identifiable) { double :scopes => [], :type => 'User' }
    let(:identity) { double :identifiable => identifiable, :admin => false, :developer => false }

    it 'should only distribute the basic scope' do
      distributor = AirMenu::ScopeDistributor.new params, identity
      expect(distributor.scope_string).to eq('basic')
    end

  end

  describe 'when scope parameter has "user owner"' do

    let(:params) { {:scope => 'user owner'} }
    let(:identifiable) { double :scopes => ['user'], :type => 'Owner' }
    let(:identity) { double :identifiable => identifiable, :admin => false, :developer => false }

    it 'should distribute the requested scopes' do
      distributor = AirMenu::ScopeDistributor.new params, identity
      expect(distributor.scope_string).to eq('basic user owner')
    end

  end

  describe 'when scope parameter has "user owner admin developer"' do

    describe 'where the user is admin and developer' do

      let(:params) { {:scope => 'user owner admin developer'} }
      let(:identifiable) { double :scopes => ['user'], :type => 'Owner' }
      let(:identity) { double :identifiable => identifiable, :admin => true, :developer => true }

      it 'should distribute the requested scopes' do
        distributor = AirMenu::ScopeDistributor.new params, identity
        expect(distributor.scope_string.split(' ')).to match_array(['basic', 'user', 'owner', 'admin', 'developer'])
      end

    end

    describe 'where the user is not admin and not developer' do

      let(:params) { {:scope => 'user owner admin developer'} }
      let(:identifiable) { double :scopes => ['user'], :type => 'Owner' }
      let(:identity) { double :identifiable => identifiable, :admin => false, :developer => false }

      it 'should not distribute all of the requested scopes' do
        distributor = AirMenu::ScopeDistributor.new params, identity
        expect(distributor.scope_string.split(' ')).to match_array(['basic', 'user', 'owner'])
      end

    end

  end

end