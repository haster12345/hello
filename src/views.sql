-- view for products with low stock counts
CREATE VIEW stock_counts AS
SELECT
  p.id AS product_id,
  p.name AS product_name,
  p.price AS product_price,
  p.stock_count AS product_stock_count,
  s.name AS seller_name,
  s.email AS seller_email
FROM
  products p
  JOIN sellers s ON p.seller_code = s.code
WHERE
  p.stock_count < 10;
