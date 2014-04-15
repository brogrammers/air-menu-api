module Api
  module V1
    class GroupsController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:admin, :owner, :get_groups]
      doorkeeper_for :update, :scopes => [:admin, :owner, :update_groups]
      doorkeeper_for :destroy, :scopes => [:admin, :owner, :delete_groups]

      before_filter :set_group, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:show, :update, :destroy]

      resource_description do
        name 'Groups'
        short_description 'All about groups in the system'
        path '/groups'
        description 'The Groups endpoint lets you inspect groups in the system.' +
                        'Only a users with the right scope can inspect groups.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      api :GET, '/groups', 'All the groups in the system'
      description 'Fetches all the groups in the system. ||admin||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/groups/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/groups/index.xml")
      def index
        @groups = Group.all
        respond_with @groups
      end

      api :GET, '/groups/:id', 'Get a group in the system'
      description 'Gets a group in the system. ||admin owner get_groups||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/groups/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/groups/show.xml")
      def show
        respond_with @group
      end

      api :PUT, '/groups/:id', 'Update a group in the system'
      description 'Updates a group in the system. ||admin owner update_groups||'
      formats [:json, :xml]
      param :name, String, 'Group name'
      example File.read("#{Rails.root}/public/docs/api/v1/groups/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/groups/update.xml")
      def update
        @group.name = params[:name] || @group.name
        @group.save!
        respond_with @group
      end

      api :DELETE, '/groups/:id', 'Delete a group in the system'
      description 'Deletes a group in the system. ||admin owner delete_groups||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/groups/destroy.json")
      example File.read("#{Rails.root}/public/docs/api/v1/groups/destroy.xml")
      def destroy
        @group.destroy
        respond_with @group
      end

      private

      def set_group
        @group = Group.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Group'
      end

      def check_ownership
        render_model_not_found 'Group' if not_admin_and?(!@user.owns(@group.restaurant))
      end

    end
  end
end