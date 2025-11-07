-- view all the ordered prodcuts for all customer
CREATE VIEW customer_orders AS
SELECT
  c.name,
  c.email,
  o.order_id,
  o.order_date,
  o.payment_status,
  p.name AS product_name,
  p.price AS product_price
FROM
  customers c
  JOIN orders o on c.id = o.customer_id
  JOIN order_items oi on o.id = oi.order_id
  JOIN products p on oi.product_id = p.id;

-- view for products with low stock counts
CREATE VIEW stock_counts AS
SELECT
  p.name,
  p.price,
  p.stock_count
FROM
  products p
WHERE
  p.stock_count < 10;
