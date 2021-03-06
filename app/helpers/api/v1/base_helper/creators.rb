module Api
  module V1
    module BaseHelper
      module Creators

        def create_company
          company = Company.new
          company.name = params[:name]
          company.website = params[:website]
          company.address = create_address
          @user.company = company
          company.save!
          company
        end

        def create_address
          address = Address.new
          address.address_1 = params[:address_1]
          address.address_2 = params[:address_2]
          address.city = params[:city]
          address.county = params[:county]
          address.state = params[:state]
          address.country = params[:country]
          address.save!
          address
        end

        def create_restaurant(company)
          restaurant = Restaurant.new
          restaurant.address = create_address
          restaurant.name = params[:name]
          restaurant.avatar = params[:avatar]
          restaurant.description = params[:description]
          restaurant.category = params[:category]
          restaurant.loyalty = false
          restaurant.remote_order = false
          restaurant.conversion_rate = 0.0
          restaurant.company = company
          restaurant.location = create_location
          restaurant.save!
          restaurant.address.save!
          restaurant.location.save!
          restaurant
        end

        def create_user
          user = User.new
          user.name = params[:name]
          user.phone = params[:phone]
          identity = create_identity
          user.identity = identity
          identity.save!
          user.save!
          user
        end

        def create_identity
          identity = Identity.new
          identity.username = params[:username]
          identity.new_password = params[:password]
          identity.email = params[:email]
          identity.avatar = params[:avatar]
          identity.admin = false
          identity.developer = false
          identity.save!
          identity
        end

        def create_order(restaurant)
          order = Order.new
          order.state = :new
          order.user = @user if @user.class == User
          order.table_number = params[:table_number]
          if @user.class == StaffMember
            order.staff_member = @user
            order.set_state
            order.open!
          end
          order.restaurant = restaurant
          order.save!
          order
        end

        def create_order_item(order, menu_item)
          order_item = OrderItem.new
          order_item.comment = params[:comment]
          order_item.order = order
          order_item.menu_item = menu_item
          order_item.count = params[:count].to_i
          order_item.state = :new
          order_item.save!
          order_item
        end

        def create_staff_kind(restaurant, staff_kind_scopes)
          staff_kind = StaffKind.new
          staff_kind.name = params[:name]
          staff_kind.accept_orders = params[:accept_orders]
          staff_kind.accept_order_items = params[:accept_order_items]
          staff_kind.restaurant = restaurant
          staff_kind_scopes.each do |scope|
            staff_kind.scopes << scope
          end
          staff_kind.save!
          staff_kind
        end

        def create_staff_member(restaurant, staff_kind)
          staff_member = StaffMember.new
          staff_member.name = params[:name]
          staff_member.restaurant = restaurant
          staff_member.staff_kind = staff_kind
          identity = create_identity
          staff_member.identity = identity
          staff_member.save!
          identity.save!
          staff_member
        end

        def create_group(restaurant, device, staff_members)
          group = Group.new
          group.restaurant = restaurant
          group.name = params[:name]
          group.device_id = device.id
          staff_members.each do |staff_member|
            group.staff_members << staff_member
          end
          group.save!
          group
        end

        def create_device(notifiable)
          device = Device.new unless device = Device.find_by_uuid(params[:uuid])
          device.name = params[:name]
          device.uuid = params[:uuid]
          device.token = params[:token]
          device.platform = params[:platform]
          notifiable.devices << device
          device.reassign_group_staff_member
          device.save!
          device
        end

        def create_location
          location = Location.new
          location.latitude = params[:latitude]
          location.longitude = params[:longitude]
          location.save!
          location
        end

        def create_credit_card(user)
          credit_card = CreditCard.new
          credit_card.number = params[:number]
          credit_card.card_type = params[:card_type]
          credit_card.month = params[:month]
          credit_card.year = params[:year]
          credit_card.cvc = params[:cvc]
          credit_card.user = user
          credit_card.save!
          credit_card
        end

        def create_application(user)
          application = Doorkeeper::Application.new
          application.name = params[:name]
          application.redirect_uri = params[:redirect_uri]
          if scope_exists? 'admin'
            application.trusted = params[:trusted] || false
          else
            application.trusted = false
          end
          user.applications << @application
          application.save!
          application
        end

        def create_menu_item(menu_section, staff_kind)
          menu_item = MenuItem.new
          menu_item.name = params[:name]
          menu_item.description = params[:description]
          menu_item.price = params[:price]
          menu_item.currency = params[:currency]
          menu_item.avatar = params[:avatar]
          menu_item.menu_section = menu_section
          menu_item.staff_kind = staff_kind if staff_kind
          menu_section.menu_items << menu_item
          menu_item.save!
          menu_item
        end

        def create_menu_section(menu)
          menu_section = MenuSection.new
          menu_section.name = params[:name]
          menu_section.description = params[:description]
          menu.menu_sections << menu_section
          menu_section.menu = menu
          menu_section.save!
          menu_section
        end

        def create_menu(restaurant)
          menu = Menu.new
          menu.name = params[:name]
          menu.save!
          restaurant.menus << menu
          if params[:active] and (scope_exists? 'add_active_menus' or scope_exists? 'owner')
            restaurant.active_menu_id = menu.id
            restaurant.save!
          end
          menu
        end

        def create_payment(order, credit_card)
          payment = Payment.new
          payment.order = order
          payment.credit_card = credit_card
          order.paid!
          payment.save!
          payment
        end

        def create_review(reviewable, user)
          review = Review.new
          review.subject = params[:subject]
          review.message = params[:message]
          review.rating = params[:rating]
          review.user = user
          review.restaurant = reviewable if reviewable.class == Restaurant
          review.menu_item = reviewable if reviewable.class == MenuItem
          review.save!
          review
        end

        def create_opening_hour(restaurant)
          opening_hour = OpeningHour.new
          opening_hour.day = params[:day]
          start_time = Time.iso8601(params[:start])
          opening_hour.start = start_time
          opening_hour.end = start_time + 60*60*params[:end].to_f
          opening_hour.restaurant = restaurant
          opening_hour.save!
          opening_hour
        end

        def create_webhook(restaurant)
          webhook = Webhook.new
          webhook.path = params[:path]
          webhook.host = params[:host]
          webhook.params = params[:params]
          webhook.headers = params[:headers]
          webhook.on_action = params[:on_action]
          webhook.on_method = params[:on_method]
          webhook.restaurant = restaurant
          webhook.save!
          webhook
        end

      end
    end
  end
end