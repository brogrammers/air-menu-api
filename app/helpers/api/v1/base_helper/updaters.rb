module Api
  module V1
    module BaseHelper
      module Updaters

        def update_company(company)
          company.name = params[:name] || company.name
          company.website = params[:website] || company.website
          company.address.address_1 = params[:address_1] || company.address.address_1
          company.address.address_2 = params[:address_2] || company.address.address_2
          company.address.city = params[:city] || company.address.city
          company.address.county = params[:county] || company.address.county
          company.address.state = params[:state] || company.address.state
          company.address.country = params[:country] || company.address.country
          company.address.save!
          company.save!
          company
        end

        def update_device(device)
          device.name = params[:name] || device.name
          device.uuid = params[:uuid] || device.uuid
          device.token = params[:token] || device.token
          device.platform = params[:platform] || device.platform
          device.save!
          device
        end

        def update_group(group, device, staff_members)
          group.name = params[:name] || group.name
          group.device_id = device.id if device
          group.empty_staff_members(params[:staff_members]) if params[:staff_members].is_a?(String) && !params[:staff_members].empty?
          staff_members.each do |staff_member|
            staff_member.group = group
            staff_member.save!
          end
          group.save!
          group
        end

        def update_user(user)
          user.name = params[:name] || user.name
          user.phone = params[:phone] if user.class == User
          update_identity user.identity
          user.save!
          user
        end

        def update_identity(identity)
          identity.username = params[:username] if params[:username]
          identity.new_password = params[:password] if params[:password]
          identity.email = params[:email] if params[:email]
          identity.avatar = params[:avatar] if params[:avatar]
          identity.save!
          identity
        end

        def update_menu_item(menu_item, staff_kind)
          menu_item.name = params[:name] || menu_item.name
          menu_item.description = params[:description] || menu_item.description
          menu_item.price = params[:price] || menu_item.price
          menu_item.currency = params[:currency] || menu_item.currency
          menu_item.avatar = params[:avatar] || menu_item.avatar
          menu_item.staff_kind = staff_kind if staff_kind
          menu_item.save!
          menu_item
        end

        def update_menu_section(menu_section, staff_kind)
          menu_section.name = params[:name] || menu_section.name
          menu_section.description = params[:description] || menu_section.description
          menu_section.staff_kind = staff_kind if staff_kind
          menu_section.save!
          menu_section
        end

        def update_menu(menu)
          if params[:active] and (scope_exists? 'add_active_menus' or scope_exists? 'owner')
            menu.restaurant.active_menu_id = menu.id
            menu.restaurant.save!
          end
          menu
        end

        def update_notification(notification)
          notification.read = params[:read] || notification.read
          notification.save!
          notification
        end

        def update_order(order)
          if @user.class == StaffMember
            order.table_number = params[:table_number] || order.table_number
            order.save!
          end
          order
        end

        def update_order_item(order_item)
          order_item.comment = params[:comment] || order_item.comment
          order_item.count = params[:count] || order_item.count
          order_item.save!
          order_item
        end

        #TODO: Break this method up to smaller method (update_address, update_location)
        def update_restaurant(restaurant)
          restaurant.name = params[:name] || restaurant.name
          restaurant.description = params[:description] || restaurant.description
          restaurant.address.address_1 = params[:address_1] || restaurant.address.address_1
          restaurant.address.address_2 = params[:address_2] || restaurant.address.address_2
          restaurant.address.city = params[:city] || restaurant.address.city
          restaurant.address.county = params[:county] || restaurant.address.county
          restaurant.address.state = params[:state] || restaurant.address.state
          restaurant.avatar = params[:avatar] || restaurant.avatar
          restaurant.category = params[:category] || restaurant.category
          restaurant.address.country = params[:country] || restaurant.address.country
          restaurant.location.latitude = params[:latitude] || restaurant.location.latitude if restaurant.location
          restaurant.location.longitude = params[:longitude] || restaurant.location.longitude if restaurant.location
          restaurant.address.save!
          restaurant.location.save! if restaurant.location
          restaurant.save!
          restaurant
        end

        def update_staff_kind(staff_kind, staff_kind_scopes)
          staff_kind.name = params[:name] || staff_kind.name
          staff_kind.accept_orders = params[:accept_orders] unless params[:accept_orders].nil?
          staff_kind.accept_order_items = params[:accept_order_items] unless params[:accept_order_items].nil?
          staff_kind.empty_scopes if staff_kind_scopes.size > 0
          staff_kind_scopes.each do |scope|
            staff_kind.scopes << scope
          end
          staff_kind.save!
          staff_kind
        end

        def update_staff_member(staff_member, staff_kind)
          staff_member.name = params[:name] || staff_member.name
          staff_member.new_staff_kind = staff_kind if staff_kind
          update_identity staff_member.identity
          staff_member.save!
          staff_member
        end

        def update_credit_card(credit_card)
          credit_card.number = params[:number] || credit_card.number
          credit_card.card_type = params[:card_type] || credit_card.card_type
          credit_card.month = params[:month] || credit_card.month
          credit_card.year = params[:year] || credit_card.year
          credit_card.cvc = params[:cvc] || credit_card.cvc
          credit_card.save!
          credit_card
        end

        def update_opening_hour(opening_hour)
          opening_hour.day = params[:day] || opening_hour.day
          if params[:start] && params[:end]
            start_time = Time.iso8601(params[:start])
            opening_hour.start = start_time
            opening_hour.end = start_time + 60*60*params[:end].to_f
          end
          opening_hour.save!
          opening_hour
        end

        def update_webhook(webhook)
          webhook.path = params[:path] || webhook.path
          webhook.host = params[:host] || webhook.host
          webhook.params = params[:params] || webhook.params
          webhook.headers = params[:headers] || webhook.headers
          webhook.on_action = params[:on_action] || webhook.on_action
          webhook.on_method = params[:on_method] || webhook.on_method
          webhook.save!
          webhook
        end

      end
    end
  end
end