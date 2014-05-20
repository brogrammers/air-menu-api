#encoding: utf-8

module AirMenu
  class DatabaseData
    MENU_ITEM = [
        {
            :name => 'Soup of the Day',
            :description => 'Served with homemade brown soda bread.',
            :price => 4.95,
            :currency => 'EUR',
            :menu_section_id => 1
        },
        {
            :name => 'Church Buffalo Chicken Wings',
            :description => 'Pan Kissed Chicken Wings Tossed in a Spicy Marinade or Tossed in a BBQ Sauce Marinade. Served with Celery Stick & Blue Cheese Sauce.',
            :price => 10.95,
            :currency => 'EUR',
            :menu_section_id => 1
        },
        {
            :name => 'Deep Fried Crispy Calamari',
            :description => 'Pan Kissed Chicken Wings Tossed in a Spicy Marinade or Tossed in a BBQ Sauce Marinade. Served with Celery Stick & Blue Cheese Sauce.',
            :price => 9.95,
            :currency => 'EUR',
            :menu_section_id => 1
        },
        {
            :name => 'The Church Spicy Nachos',
            :description => 'Tortilla Chips with special recipe Spiced  beef, melted cheese and topped with spring  onions and Jalepnos served with Salsa, Guacamole and sour cream.',
            :price => 6.95,
            :currency => 'EUR',
            :menu_section_id => 1
        },
        {
            :name => 'The Classic Burger',
            :description => 'Tortilla Chips with special recipe Spiced  beef, melted cheese and topped with spring  onions and Jalepnos served with Salsa, Guacamole and sour cream.',
            :price => 13.95,
            :currency => 'EUR',
            :menu_section_id => 2
        },
        {
            :name => 'Fillet Steak Sandwich',
            :description => 'Medallions of Fillet Steak 6oz (Cooked  Medium). Served On Toasted Ciabatta Bread with Shoe String Onions, Hand Cut Chips & Pepper Sauce.',
            :price => 15.95,
            :currency => 'EUR',
            :menu_section_id => 2
        },
        {
            :name => 'Baked Fillet of irish Salmon',
            :description => 'Served with Sautéed Baby Potatoes,  Asparagus Spears & Salsa Verde.',
            :price => 14.95,
            :currency => 'EUR',
            :menu_section_id => 2
        },
        {
            :name => 'Vegetable Thai Curry',
            :description => 'Potatoes, Fried Shallot, Peppers, Mushrooms. Aubergines, Snow Peas, in a Coconut,  Lemongrass & Ginger Cream Sauce, Served  with Basmati Rice.',
            :price => 10.95,
            :currency => 'EUR',
            :menu_section_id => 2
        },
        {
            :name => 'Beef Lasagne',
            :description => 'Served with Hand Cut Chips or Side Salad.',
            :price => 13.50,
            :currency => 'EUR',
            :menu_section_id => 2
        },
        {
            :name => 'Fish & Chips',
            :description => 'Tempura Battered Cod served with Hand Cut Chips Mushy Peas and Tartar Sauce.',
            :price => 14.95,
            :currency => 'EUR',
            :menu_section_id => 2
        },
        {
            :name => 'The Church Beef & Guinness Stew',
            :description => 'Served with Shallots, Baby Mushrooms, Root Vegetables & Baby Potatoes.',
            :price => 12.95,
            :currency => 'EUR',
            :menu_section_id => 2
        },
        {
            :name => 'Chicken Wrap',
            :description => 'Diced Supreme of chicken marinated in sweet chilli sauce with grated mozzarella  in a soft toasted wrap (Served with side salad).',
            :price => 7.95,
            :currency => 'EUR',
            :menu_section_id => 3
        },
        {
            :name => 'Tomato & Mozzarella Crostini',
            :description => 'Sliced Beef Tomato with fresh buffalo  mozzarella cheese and slow roasted  tomato pesto on Foccaia bread.',
            :price => 7.95,
            :currency => 'EUR',
            :menu_section_id => 3
        },
        {
            :name => 'Roast Chicken with Herb Stuffing',
            :description => 'Light Mayonnaise on a Soft Onion Bap,  served with a Wild Rocket & Beetroot Salad.',
            :price => 8.95,
            :currency => 'EUR',
            :menu_section_id => 3
        },
        {
            :name => 'BLT',
            :description => 'Crispy Bacon, Iceberg Lettuce, Beef Tomato, Mary Rose Sauce, on a Sour Dough Roll, Served with Hand Cut Chips.',
            :price => 12.95,
            :currency => 'EUR',
            :menu_section_id => 3
        },
        {
            :name => 'Ham and Cheese Bagel',
            :description => 'Hand Carved Limerick Ham, Smoked  Applewood Cheese, Apple & Raisin Chutney  on a toasted poppy seed bagel. Served with Sweet Potato Fries.',
            :price => 8.95,
            :currency => 'EUR',
            :menu_section_id => 3
        },
        {
            :name => 'Chicken Caesar Salad',
            :description => 'Delicate Slices of Traditional Oak Smoked Salmon, garnished with Baby Capers & served with Brown Bread.',
            :price => 11.95,
            :currency => 'EUR',
            :menu_section_id => 4
        },
        {
            :name => 'Wrights of Marino Smoked Salmon Salad',
            :description => 'Baby Gem Lettuce, Garlic Croutons,  Lardons of Bacon, Shaved Parmesan  Cheese, Classic Caesar Dressing.',
            :price => 9.95,
            :currency => 'EUR',
            :menu_section_id => 4
        },
        {
            :name => 'Asian Duck Salad',
            :description => 'Asian infused Salad of Crisp Warm Duck tossed with Bean Sprouts, Pok Choi, toasted Cashew Nuts, Orange Segments & Asian Greens in a House Dressing of Sweet Chilli, Garlic & Coriander.',
            :price => 12.95,
            :currency => 'EUR',
            :menu_section_id => 4
        },
        {
            :name => 'Guinness',
            :description => '',
            :price => 5.20,
            :currency => 'EUR',
            :menu_section_id => 5
        },
        {
            :name => 'O\'Hara\'s Stout',
            :description => '',
            :price => 5.20,
            :currency => 'EUR',
            :menu_section_id => 5
        },
        {
            :name => 'O\'Hara\'s Red Ale',
            :description => '',
            :price => 5.20,
            :currency => 'EUR',
            :menu_section_id => 5
        },
        {
            :name => 'Dark Arts Porter',
            :description => '',
            :price => 5.60,
            :currency => 'EUR',
            :menu_section_id => 5
        },
        {
            :name => 'Becks Vier',
            :description => '',
            :price => 5.80,
            :currency => 'EUR',
            :menu_section_id => 6
        },
        {
            :name => 'Stella Artois',
            :description => '',
            :price => 5.80,
            :currency => 'EUR',
            :menu_section_id => 6
        },
        {
            :name => 'Kaiser Beer',
            :description => '',
            :price => 6.10,
            :currency => 'EUR',
            :menu_section_id => 6
        },
        {
            :name => 'Hoegarden',
            :description => '',
            :price => 6.10,
            :currency => 'EUR',
            :menu_section_id => 6
        },
        {
            :name => 'Franziskaner Weis',
            :description => '',
            :price => 6.10,
            :currency => 'EUR',
            :menu_section_id => 6
        },
        {
            :name => 'Corona',
            :description => '',
            :price => 5.70,
            :currency => 'EUR',
            :menu_section_id => 7
        },
        {
            :name => 'Corona Light',
            :description => '',
            :price => 5.70,
            :currency => 'EUR',
            :menu_section_id => 7
        },
        {
            :name => 'Desperado',
            :description => '',
            :price => 6.00,
            :currency => 'EUR',
            :menu_section_id => 7
        },
        {
            :name => 'Heineken',
            :description => '',
            :price => 5.60,
            :currency => 'EUR',
            :menu_section_id => 7
        },
        {
            :name => 'Coors Light',
            :description => '',
            :price => 5.60,
            :currency => 'EUR',
            :menu_section_id => 7
        },
        {
            :name => 'Paulaner',
            :description => '',
            :price => 6.30,
            :currency => 'EUR',
            :menu_section_id => 7
        },
        {
            :name => 'Budweiser',
            :description => '',
            :price => 5.60,
            :currency => 'EUR',
            :menu_section_id => 7
        },
        {
            :name => 'Chicken Butterfly',
            :description => 'Succulent chicken breasts in crispy skin. No bones about it - pure class!',
            :price => 10.25,
            :currency => 'EUR',
            :menu_section_id => 8
        },
        {
            :name => '1/4 Chicken Breast',
            :description => '',
            :price => 7.20,
            :currency => 'EUR',
            :menu_section_id => 8
        },
        {
            :name => '1/4 Chicken Leg',
            :description => '',
            :price => 7.20,
            :currency => 'EUR',
            :menu_section_id => 8
        },
        {
            :name => '1/2 Chicken',
            :description => '',
            :price => 9.95,
            :currency => 'EUR',
            :menu_section_id => 8
        },
        {
            :name => '5 Chicken Wings',
            :description => '',
            :price => 8.40,
            :currency => 'EUR',
            :menu_section_id => 8
        },
        {
            :name => 'Wing Platter',
            :description => 'For 2-3 people to share. 10 Chicken Wings + 2 Large or 4 Reg Sides',
            :price => 16.80,
            :currency => 'EUR',
            :menu_section_id => 9
        },
        {
            :name => 'Full Platter',
            :description => 'For 2-3 people to share. Whole Chicken + 2 Large or 4 Reg Sides',
            :price => 19.85,
            :currency => 'EUR',
            :menu_section_id => 9
        },
        {
            :name => 'Meal Platter',
            :description => 'For 2 people to share. Whole Chicken + 1 Large or 2 Reg Sides + 2 Bottomless Soft Drinks',
            :price => 19.85,
            :currency => 'EUR',
            :menu_section_id => 9
        },
        {
            :name => 'Jumbo Platter',
            :description => 'For 4-6 people to share. 2 Whole Chickens + 5 Large Sides',
            :price => 43.50,
            :currency => 'EUR',
            :menu_section_id => 9
        },
        {
            :name => 'Chicken Breast Fillet Burger',
            :description => '',
            :price => 8.90,
            :currency => 'EUR',
            :menu_section_id => 10
        },
        {
            :name => 'Chicken Breast Fillet Pitta',
            :description => '',
            :price => 8.95,
            :currency => 'EUR',
            :menu_section_id => 10
        },
        {
            :name => 'Chicken Breast Fillet Wrap',
            :description => '',
            :price => 9.95,
            :currency => 'EUR',
            :menu_section_id => 10
        },
        {
            :name => 'Double Chicken Breast Fillet Burger',
            :description => '',
            :price => 12.20,
            :currency => 'EUR',
            :menu_section_id => 10
        },
        {
            :name => 'Avocado and Green Bean Salad',
            :description => 'With sweet, roasted red onions and crunchy leaves balanced with a tangy dressing. Sprinkled with sesame and toasted seeds.',
            :price => 9.25,
            :currency => 'EUR',
            :menu_section_id => 11
        },
        {
            :name => 'Mediterranean Salad',
            :description => 'Piccolo tomatoes, cucumbers, celery, sweet zingy peppers and mixed leaves in paprika dressing. Sprinkled with olives and feta cheese.',
            :price => 7.80,
            :currency => 'EUR',
            :menu_section_id => 11
        },
        {
            :name => 'Caesar Salad',
            :description => 'Cos lettuce sprinkled with tangy grated cheese, Caesar dressing & crunchy croutons. Classic.',
            :price => 9.10,
            :currency => 'EUR',
            :menu_section_id => 11
        },
        {
            :name => 'Sagres Beer (Portugal)',
            :description => '(330ml) Portugal\'s favourite golden lager.',
            :price => 3.60,
            :currency => 'EUR',
            :menu_section_id => 12
        },
        {
            :name => 'Superbock Beer (Portugal)',
            :description => '(330ml) Strong and crisp lager that packs punch.',
            :price => 3.60,
            :currency => 'EUR',
            :menu_section_id => 12
        },
        {
            :name => 'Brahma Beer (Brazil)',
            :description => '(330ml) Easy-drinking pale lager. Highly refreshing.',
            :price => 3.60,
            :currency => 'EUR',
            :menu_section_id => 12
        },
        {
            :name => 'Savanna Cider (S.Africa)',
            :description => '(330ml) Distinctly appley. It\'s dry but you can drink it!',
            :price => 3.60,
            :currency => 'EUR',
            :menu_section_id => 12
        },
        {
            :name => 'Bottomless Soft Drinks',
            :description => 'Coca-Cola, Diet Coke, Fanta, Sprite (Per Person)',
            :price => 2.45,
            :currency => 'EUR',
            :menu_section_id => 13
        },
        {
            :name => 'Pressed Apple Juice',
            :description => 'Coca-Cola, Diet Coke, Fanta, Sprite (Per Person)',
            :price => 2.45,
            :currency => 'EUR',
            :menu_section_id => 13
        },
        {
            :name => 'Bottomless Soft Drinks',
            :description => 'Coca-Cola, Diet Coke, Fanta, Sprite (Per Person)',
            :price => 2.45,
            :currency => 'EUR',
            :menu_section_id => 13
        },
        {
            :name => 'Bottomless Soft Drinks',
            :description => 'Coca-Cola, Diet Coke, Fanta, Sprite (Per Person)',
            :price => 2.45,
            :currency => 'EUR',
            :menu_section_id => 13
        },
        {
            :name => 'Bottomless Soft Drinks',
            :description => 'Coca-Cola, Diet Coke, Fanta, Sprite (Per Person)',
            :price => 2.45,
            :currency => 'EUR',
            :menu_section_id => 13
        }
    ]
  end
end