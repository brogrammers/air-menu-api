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

      end
    end
  end
end