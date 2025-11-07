BEGIN TRANSACTION;

-- ========================
-- CUSTOMERS
-- ========================
INSERT INTO
  customers (
    id,
    email,
    name,
    date_of_brith,
    phone_number,
    address,
    type,
    loyalty_points
  )
VALUES
  (
    1,
    'alice.smith@example.com',
    'Alice Smith',
    '1995-03-12',
    '+447712345678',
    '12 Green St, London',
    'premium',
    320
  ),
  (
    2,
    'bob.jones@example.com',
    'Bob Jones',
    '1988-11-05',
    '+447798112233',
    '45 High Rd, Manchester',
    'standard',
    120
  ),
  (
    3,
    'charlie.lee@example.com',
    'Charlie Lee',
    '1992-06-24',
    '+447700223344',
    '22 Queen Ave, Bristol',
    'standard',
    80
  ),
  (
    4,
    'diana.khan@example.com',
    'Diana Khan',
    '1999-09-18',
    '+447733556677',
    '99 Oxford St, London',
    'premium',
    540
  ),
  (
    5,
    'edward.ng@example.com',
    'Edward Ng',
    '1990-02-14',
    '+447788998877',
    '3 George Sq, Glasgow',
    'standard',
    200
  );

-- ========================
-- CARDS
-- ========================
INSERT INTO
  cards (customer_id, pan, expiry_date, cvv, is_default)
VALUES
  (1, 1, '4929123456789012', '2027-05', '123', 1),
  (2, 1, '4929765432109876', '2026-10', '456', 0),
  (3, 2, '5200001111222233', '2028-01', '789', 0),
  (4, 3, '4532009988776655', '2025-12', '321', 0),
  (5, 4, '4716001122334455', '2026-03', '432', 0),
  (6, 5, '4000123412341234', '2027-07', '555', 0);

-- ========================
-- SELLERS
-- ========================
INSERT INTO
  sellers (code, address, name, tax_id, rating)
VALUES
  (
    'SEL001',
    '10 Market St, Birmingham',
    'TechNova Ltd',
    'GB123456789',
    '4.6'
  ),
  (
    'SEL002',
    '5 Commerce Ave, Leeds',
    'HomeStyle Co',
    'GB987654321',
    '4.2'
  ),
  (
    'SEL003',
    '77 Station Rd, Cardiff',
    'GadgetWorld',
    'GB112233445',
    '4.8'
  );

-- ========================
-- PRODUCTS
-- ========================
INSERT INTO
  products (
    id,
    name,
    description,
    brand,
    colour,
    dimensions,
    weight,
    price,
    n_days_warranty,
    category,
    stock_count,
    seller_code
  )
VALUES
  (
    1,
    'Wireless Mouse',
    'Ergonomic 2.4GHz mouse',
    'LogiTech',
    'Black',
    '10x6x4 cm',
    '85g',
    24.99,
    365,
    'Electronics',
    120,
    'SEL001'
  ),
  (
    2,
    'Mechanical Keyboard',
    'RGB backlit keyboard',
    'Corsair',
    'White',
    '44x13x4 cm',
    '950g',
    89.99,
    730,
    'Electronics',
    80,
    'SEL001'
  ),
  (
    3,
    'Electric Kettle',
    '1.7L stainless steel kettle',
    'Russell Hobbs',
    'Silver',
    '20x15x22 cm',
    '1.1kg',
    39.99,
    365,
    'Appliances',
    150,
    'SEL002'
  ),
  (
    4,
    'LED Desk Lamp',
    'Adjustable brightness lamp',
    'Philips',
    'White',
    '12x12x35 cm',
    '600g',
    29.99,
    365,
    'Home',
    200,
    'SEL002'
  ),
  (
    5,
    'Bluetooth Speaker',
    'Portable waterproof speaker',
    'JBL',
    'Blue',
    '18x7x7 cm',
    '500g',
    59.99,
    730,
    'Electronics',
    90,
    'SEL003'
  ),
  (
    6,
    'Smartwatch',
    'Fitness tracking smartwatch',
    'Fitbit',
    'Black',
    '4x4x1 cm',
    '30g',
    129.99,
    730,
    'Wearables',
    50,
    'SEL003'
  );

-- ========================
-- BASKET
-- ========================
INSERT INTO
  basket (customer_id, product_id, quantity)
VALUES
  (1, 2, 1),
  (1, 5, 2),
  (2, 3, 3),
  (3, 1, 4),
  (4, 6, 5),
  (5, 4, 6);

-- ========================
-- VOUCHERS
-- ========================
INSERT INTO
  vouchers (serial, amount, customer_id)
VALUES
  ('VCH001', 10.0, 1),
  ('VCH002', 5.0, 2),
  ('VCH003', 15.0, 4);

-- ========================
-- REVIEWS
-- ========================
INSERT INTO
  reviews (id, product_id, description, score)
VALUES
  (1, 1, 'Very responsive and comfortable to use', 5),
  (2, 3, 'Heats up quickly, very convenient', 4),
  (3, 2, 'Excellent typing feel, but a bit noisy', 4),
  (4, 5, 'Sound quality is amazing for the price', 5),
  (
    5,
    6,
    'Great for workouts, battery could be better',
    4
  );

-- ========================
-- ORDERS
-- amount_total has to be calculated based on the order items using a trigger
-- ========================
INSERT INTO
  orders (
    id,
    customer_id,
    order_date,
    payment_status,
    amount_total
  )
VALUES
  (6, 1, '2025-10-12 00:00:00', 'paid', 114.98),
  (2, 2, '2025-10-20 00:00:00', 'paid', 39.99),
  (3, 3, '2025-09-05 00:00:00', 'paid', 24.99),
  (4, 4, '2025-08-30 00:00:00', 'paid', 189.98),
  (5, 5, '2025-10-01 00:00:00', 'pending', 29.99);

-- ========================
-- ORDER ITEMS
-- ========================
INSERT INTO
  order_items (order_id, product_id, quantity)
VALUES
  (1, 2, 1),
  (1, 5, 1),
  (2, 3, 1),
  (3, 1, 1),
  (4, 6, 1),
  (5, 4, 1);

-- ========================
-- DELIVERIES
-- ========================
INSERT INTO
  deliveries (order_id, tracking_number)
VALUES
  (1, 10001),
  (2, 10002),
  (3, 10003),
  (4, 10004),
  (5, 10005);

-- ========================
-- RETURNS
-- refund_total has to be calculated based on the return items using a trigger
-- ========================
INSERT INTO
  returns (
    id,
    order_id,
    ticket_number,
    tracking_number,
    start_date,
    due_date,
    refund_total,
    status
  )
VALUES
  (
    1,
    2,
    5001,
    20001,
    '2025-10-25 00:00:00',
    '2025-11-05 00:00:00',
    39.99,
    'Processed'
  ),
  (
    2,
    4,
    5002,
    20002,
    '2025-09-10 00:00:00',
    '2025-09-20 00:00:00',
    129.99,
    'Refunded'
  );

-- ========================
-- RETURN ITEMS
-- ========================
INSERT INTO
  return_items (return_id, quantity, product_id)
VALUES
  (1, 1, 3),
  (2, 1, 6);

COMMIT;
