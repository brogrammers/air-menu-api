#encoding: utf-8

module AirMenu
  class DatabaseData
    REVIEW = [
        {
            :subject => 'Amazing Food',
            :message => 'The food is good, the service is fast and the location is perfect! Who would have thought a Church can be used a Bar.',
            :rating => 5,
            :user_id => 1,
            :restaurant_id => 1
        },
        {
            :subject => 'Great Atmosphere',
            :message => 'Had an amazing time at the Church! One of the only proper beer gardens in Dublin.',
            :rating => 5,
            :user_id => 2,
            :restaurant_id => 1
        },
        {
            :subject => 'Good Service',
            :message => 'The service was very good! Will visit again',
            :rating => 4,
            :user_id => 4,
            :restaurant_id => 1
        },
        {
            :subject => 'Amazing Beer selection',
            :message => 'I was surprised by the huge beer selection!',
            :rating => 4,
            :user_id => 5,
            :restaurant_id => 1
        },
        {
            :subject => 'Never again',
            :message => 'It was way to crowed, no chance to get served, and the staff seemed very unfriendly.',
            :rating => 1,
            :user_id => 6,
            :restaurant_id => 1
        }
    ]
  end
end