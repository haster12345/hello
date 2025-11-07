-- 5.1 Customers order history
SELECT
  c.name,
  c.email,
  o.id AS order_id,
  o.order_date,
  o.payment_status,
  o.amount_total,
  p.name AS product_name,
  p.price AS product_price,
  pa.status AS payment_status
FROM
  customers c
  JOIN orders o on c.id = o.customer_id
  JOIN order_items oi on o.id = oi.order_id
  JOIN products p on oi.product_id = p.id
  JOIN payments pa ON o.id = pa.order_id
  AND pa.status = 'paid'
  OR pa.status = 'pending';

-- 5.2 Basket analysis
SELECT
  c.id AS customer_id,
  c.name AS customer_name,
  c.email AS customer_email,
  v.amount AS voucher_amount,
  p.name AS product_name
FROM
  basket b
  JOIN customers c ON b.customer_id = c.id
  JOIN products p ON b.product_id = p.id
  JOIN vouchers v ON c.id = v.customer_id;

-- 5.3 Top products in every category by revenue
-- need to add average rating and return rate
WITH
  product_revenue AS (
    SELECT
      p.category AS product_category,
      p.name AS product_name,
      p.stock_count AS product_stock_count,
      SUM(oi.quantity * p.price) AS revenue
    FROM
      orders o
      JOIN order_items oi ON o.id = oi.order_id
      JOIN products p ON oi.product_id = p.id
    GROUP BY
      p.id,
      p.category,
      p.name,
      p.stock_count
  ),
  ranked_products AS (
    SELECT
      product_category,
      product_name,
      product_stock_count,
      revenue,
      ROW_NUMBER() OVER (
        PARTITION BY
          product_category
        ORDER BY
          revenue DESC
      ) AS rank_in_category
    FROM
      product_revenue
  )
SELECT
  product_category,
  product_name,
  product_stock_count,
  revenue
FROM
  ranked_products
WHERE
  rank_in_category <= 3
ORDER BY
  product_category,
  revenue DESC;

-- 5.4 Sales trends: month-on-month sales growth
WITH
  monthly_sales AS (
    SELECT
      COUNT(DISTINCT p.id) - COUNT(DISTINCT ri.product_id) AS product_count,
      STRFTIME('%Y-%m', o.order_date) AS order_month,
      SUM(
        oi.quantity * p.price - COALESCE(ri.quantity, 0) * p.price
      ) AS sales
    FROM
      orders o
      JOIN order_items oi ON o.id = oi.order_id
      JOIN products p ON oi.product_id = p.id
      LEFT JOIN returns r ON o.id = r.order_id
      LEFT JOIN return_items ri ON r.id = ri.return_id
      AND ri.product_id = p.id
    GROUP BY
      STRFTIME('%Y-%m', o.order_date)
  )
SELECT
  order_month,
  product_count,
  sales,
  LAG(sales) OVER (
    ORDER BY
      order_month
  ) AS prev_month_sales,
  (
    sales - LAG(sales) OVER (
      ORDER BY
        order_month
    )
  ) / LAG(sales) OVER (
    ORDER BY
      order_month
  ) AS growth_rate
FROM
  monthly_sales
ORDER BY
  order_month;
