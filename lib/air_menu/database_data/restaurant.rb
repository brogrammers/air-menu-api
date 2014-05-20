#encoding: utf-8

module AirMenu
  class DatabaseData
    RESTAURANT = [
        {
            :name => 'The Church',
            :description => 'St. Mary’s closed in 1964 and lay derelict for a number of years until it was purchased by John Keating in 1997. Following extensive restoration over a seven year period, this List 1 building finally re-opened its doors in December 2005 as John M. Keating’s Bar. The tasteful conversion and refurbishment of this Dublin landmark was acknowledged at the Dublin City Neighbourhood Awards 2006, where it won first prize in the category of Best Old Building In September 2007 the building was acquired by new owners and renamed "The Church Bar & Restaurant" and its range of services was expanded to include a Cafe, Night Club and a Barbeque area on the terrace.',
            :loyalty => false,
            :remote_order => false,
            :conversion_rate => 0.0,
            :company_id => 1,
            :active_menu_id => 1,
            :avatar => '/uploads/restaurant/avatar/1/avatar.jpg'
        },
        {
            :name => 'Nandos',
            :description => 'Home of the legendary, Portuguese flame-grilled PERi-PERi chicken.',
            :loyalty => false,
            :remote_order => false,
            :conversion_rate => 0.0,
            :company_id => 1,
            :active_menu_id => 2,
            :avatar => '/uploads/restaurant/avatar/2/avatar.jpg'
        }
    ]
  end
end