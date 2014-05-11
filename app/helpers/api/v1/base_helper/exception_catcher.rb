module Api
  module V1
    module BaseHelper
      module ExceptionCatcher

        ActionController::Base.rescue_from ActiveRecord::RecordNotFound do |exception|
          render_model_not_found
        end

        ActionController::Base.rescue_from Order::StateError do |exception|
          render_conflict 'order_error'
        end

        ActionController::Base.rescue_from OrderItem::StateError do |exception|
          render_conflict 'order_item_error'
        end

        ActionController::Base.rescue_from Group::MismatchError do |exception|
          render_conflict 'wrong_staff_kind'
        end

        ActionController::Base.rescue_from Apipie::ParamMissing do |exception|
          render_bad_request [exception.param]
        end

        ActionController::Base.rescue_from Apipie::ParamInvalid do |exception|
          render_bad_request [exception.param]
        end

        ActionController::Base.rescue_from StaffMember::GroupMemberError do |exception|
          render_conflict 'group_member_conflict'
        end

      end
    end
  end
end