BEGIN TRANSACTION;

-- situation (i)
-- Create a trigger to check if the product is in stock before placing an order
CREATE TRIGGER IF NOT EXISTS check_stock_before_order BEFORE INSERT ON order_items FOR EACH ROW WHEN (
  SELECT
    stock_count
  FROM
    products
  WHERE
    id = NEW.product_id
) < NEW.quantity BEGIN
SELECT
  RAISE (ABORT, 'Insufficient stock');

END;

-- situation (iv)
-- Create trigger to automatically update stock count after an order is placed
CREATE TRIGGER IF NOT EXISTS update_stock_after_order AFTER INSERT ON order_items FOR EACH ROW BEGIN
UPDATE products
SET
  stock_count = stock_count - NEW.quantity
WHERE
  id = NEW.product_id;

END;

-- Create a trigger to populate amount_total in orders from order_items
CREATE TRIGGER IF NOT EXISTS populate_amount_total AFTER INSERT ON order_items FOR EACH ROW BEGIN
UPDATE orders
SET
  amount_total = amount_total + (
    SELECT
      price
    FROM
      products
    where
      id = NEW.product_id
  ) * NEW.quantity
WHERE
  id = NEW.order_id;

END;

COMMIT;