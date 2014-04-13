module Doorkeeper
  module Helpers
    module Filter
      module ClassMethods
        def doorkeeper_for(*args)
          doorkeeper_for = DoorkeeperForBuilder.create_doorkeeper_for(*args)

          before_filter doorkeeper_for.filter_options do
            valid_token = doorkeeper_for.validate_token(doorkeeper_token)
            valid_scopes = doorkeeper_for.validate_token_scopes(doorkeeper_token)
            unless valid_token && valid_scopes
              @error = OAuth::InvalidTokenResponse.from_access_token(doorkeeper_token)
              headers.merge!(@error.headers.reject {|k, v| ['Content-Type'].include? k })
              render_options = doorkeeper_forbidden_render_options @error unless valid_scopes
              render_options = doorkeeper_unauthorized_render_options @error unless valid_token

              if render_options.nil? || render_options.empty?
                head :forbidden unless valid_scopes
                head :unauthorized unless valid_token
              else
                render_options[:status] = :forbidden unless valid_scopes
                render_options[:status] = :unauthorized unless valid_token
                render_options[:layout] = false if render_options[:layout].nil?
                render render_options
              end
            end
          end
        end

        def doorkeeper_forbidden_render_options(error)
          nil
        end

        def doorkeeper_unauthorized_render_options(error)
          nil
        end
      end
    end
  end
end