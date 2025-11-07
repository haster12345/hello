BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS customers (
  id INTEGER PRIMARY KEY,
  email TEXT UNIQUE,
  name TEXT,
  date_of_brith TEXT,
  phone_number TEXT,
  address TEXT,
  type TEXT,
  loyalty_points INTEGER
);

CREATE TABLE IF NOT EXISTS cards (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER,
  pan TEXT,
  expiry_date TEXT,
  cvv TEXT,
  is_default INTEGER,
  FOREIGN KEY (customer_id) REFERENCES customers (id)
);

CREATE TABLE IF NOT EXISTS payments (
  txn_id INTEGER PRIMARY KEY,
  order_id INTEGER,
  payment_method TEXT,
  amount REAL,
  status TEXT,
  date TEXT,
  FOREIGN KEY (order_id) REFERENCES orders (id)
);

CREATE TABLE IF NOT EXISTS vouchers (
  serial TEXT PRIMARY KEY,
  amount REAL,
  customer_id INTEGER,
  FOREIGN KEY (customer_id) REFERENCES customers (id)
);

CREATE TABLE IF NOT EXISTS products (
  id INTEGER PRIMARY KEY,
  name TEXT,
  description TEXT,
  brand TEXT,
  colour TEXT,
  dimensions TEXT,
  weight TEXT,
  price REAL,
  n_days_warranty INTEGER,
  category TEXT,
  stock_count INTEGER,
  seller_code TEXT,
  FOREIGN KEY (seller_code) REFERENCES sellers (code)
);

CREATE TABLE IF NOT EXISTS basket (
  customer_id INTEGER,
  product_id INTEGER,
  quantity INTEGER,
  FOREIGN KEY (customer_id) REFERENCES customers (id),
  FOREIGN KEY (product_id) REFERENCES products (id)
);

CREATE TABLE IF NOT EXISTS sellers (
  code TEXT PRIMARY KEY,
  address TEXT,
  name TEXT,
  tax_id TEXT,
  rating TEXT
);

CREATE TABLE IF NOT EXISTS reviews (
  id INTEGER PRIMARY KEY,
  product_id INTEGER,
  description TEXT,
  score INTEGER,
  FOREIGN KEY (product_id) REFERENCES products (id)
);

CREATE TABLE IF NOT EXISTS orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER,
  order_date TEXT,
  payment_status TEXT,
  amount_total FLOAT,
  FOREIGN KEY (customer_id) REFERENCES customers (id)
);

CREATE TABLE IF NOT EXISTS order_items (
  order_id INTEGER,
  product_id INTEGER,
  quantity INTEGER,
  FOREIGN KEY (order_id) REFERENCES orders (id),
  FOREIGN KEY (product_id) REFERENCES products (id)
);

CREATE TABLE IF NOT EXISTS deliveries (
  order_id INTEGER,
  tracking_number INTEGER,
  FOREIGN KEY (order_id) REFERENCES orders (id)
);

-- returns are linked to orders
CREATE TABLE IF NOT EXISTS returns (
  id INTEGER PRIMARY KEY,
  order_id INTEGER,
  ticket_number INTEGER,
  tracking_number INTEGER,
  start_date TEXT,
  due_date TEXT,
  refund_total FLOAT,
  status TEXT,
  FOREIGN KEY (order_id) REFERENCES orders (id)
);

CREATE TABLE IF NOT EXISTS return_items (
  return_id INTEGER,
  quantity INTEGER,
  product_id INTEGER,
  FOREIGN KEY (return_id) REFERENCES returns (id),
  FOREIGN KEY (product_id) REFERENCES products (id)
);

COMMIT;
