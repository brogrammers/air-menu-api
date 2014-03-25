module Api
  module V1
    module BaseHelper
      module Errors

        def render_route_not_found
          render @format => {:error => {:code => 'route_not_found'}}, :status => :not_found
        end

        def render_model_not_found(model_name = nil)
          model_name = model_name ? model_name : 'unknown'
          render @format => {:error => {:code => 'model_not_found', :model => model_name}}, :status => :not_found
        end

        def render_forbidden(error = nil)
          error_message = error || 'unknown'
          render @format => {:error => {:code => 'forbidden', :message => error_message}}, :status => :forbidden
        end

        def render_bad_request(error = nil)
          render @format => {:error => {:code => 'parameters', :parameters => error || []}}, :status => :bad_request
        end

        def render_conflict(error = nil)
          error_message = error || 'unknown'
          render @format => {:error => {:code => 'conflict', :message => error_message}}, :status => :conflict
        end

      end
    end
  end
end