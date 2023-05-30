{{
    config(materialized="table")
}}

WITH CUSTOMERS AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

ORDERS AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

ORDER_ITEMS AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),

PRODUCTS AS (
    SELECT * FROM {{ ref('stg_products') }}
),

ACTIVE_ORDERS AS (
  SELECT
    *
  FROM ORDERS
  WHERE STATUS <> 'cancelled'
),

CUSTOMER_DETAILS AS (
    SELECT
        ID AS CUSTOMER_ID,
        FIRST_NAME || ' ' || LAST_NAME AS FULL_NAME
    FROM CUSTOMERS
),

ORDER_COUNT_BY_CUSTOMER AS (
    SELECT
        CUSTOMER_ID,
        COUNT(*) AS ORDER_COUNT
    FROM ACTIVE_ORDERS
    GROUP BY 1
    ORDER BY 2 DESC
),

ORDER_ITEM_TOTALS AS (
    SELECT
        ACTIVE_ORDERS.ID AS ORDER_ID,
        PRODUCTS.NAME AS PRODUCT_NAME,
        ORDER_ITEMS.QUANTITY AS QUANTITY,
        PRODUCTS.PRICE AS UNIT_PRICE,
        (ORDER_ITEMS.QUANTITY * PRODUCTS.PRICE)::NUMBER(10, 2) AS UNIT_TOTAL
    FROM ACTIVE_ORDERS
    LEFT JOIN ORDER_ITEMS ON ACTIVE_ORDERS.ID = ORDER_ITEMS.ORDER_ID
    LEFT JOIN PRODUCTS ON ORDER_ITEMS.PRODUCT_ID = PRODUCTS.ID
),

ORDER_TOTALS AS (
    SELECT
        ORDER_ID,
        SUM(UNIT_TOTAL) AS ORDER_TOTALS
    FROM ORDER_ITEM_TOTALS
    GROUP BY 1
    HAVING ORDER_TOTALS IS NOT NULL
    ORDER BY 2 DESC
),

CUSTOMER_TOTALS AS (
    SELECT
        CUSTOMER_ID,
        SUM(ORDER_TOTALS) AS TOTAL_AMOUNT_SPENT
    FROM ORDER_TOTALS
    LEFT JOIN ORDERS ON ORDER_TOTALS.ORDER_ID = ORDERS.ID
    GROUP BY 1
    ORDER BY 2 DESC
),

CUSTOMER_ORDER_HISTORY AS (
    SELECT
        CUSTOMER_ID,
        MIN(DATE) AS FIRST_ORDER_DATE,
        MAX(DATE) AS LAST_ORDER_DATE
    FROM ACTIVE_ORDERS
    GROUP BY 1
),

CUSTOMER_SUMMARY AS (
    SELECT
        CUSTOMER_DETAILS.CUSTOMER_ID,
        CUSTOMER_DETAILS.FULL_NAME,
        ORDER_COUNT_BY_CUSTOMER.ORDER_COUNT,
        CUSTOMER_TOTALS.TOTAL_AMOUNT_SPENT,
        CUSTOMER_ORDER_HISTORY.FIRST_ORDER_DATE,
        CUSTOMER_ORDER_HISTORY.LAST_ORDER_DATE
    FROM CUSTOMER_DETAILS
    LEFT JOIN ORDER_COUNT_BY_CUSTOMER ON CUSTOMER_DETAILS.CUSTOMER_ID = ORDER_COUNT_BY_CUSTOMER.CUSTOMER_ID
    LEFT JOIN CUSTOMER_TOTALS ON CUSTOMER_DETAILS.CUSTOMER_ID = CUSTOMER_TOTALS.CUSTOMER_ID
    LEFT JOIN CUSTOMER_ORDER_HISTORY ON CUSTOMER_DETAILS.CUSTOMER_ID = CUSTOMER_ORDER_HISTORY.CUSTOMER_ID
    WHERE TOTAL_AMOUNT_SPENT IS NOT NULL
    ORDER BY TOTAL_AMOUNT_SPENT DESC
    LIMIT 10
)

SELECT * FROM CUSTOMER_SUMMARY
