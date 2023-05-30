{{
    config(materialized="table")
}}

WITH CUSTOMERS AS (
    SELECT
        *
    FROM {{ ref('stg_customers') }}
),

ORDERS AS (
    SELECT
        *
    FROM {{ ref('stg_orders') }}
	WHERE STATUS <> 'cancelled'
),

FINAL AS (
    SELECT
        ORDERS.CUSTOMER_ID AS CUSTOMER_ID,
        CUSTOMERS.FIRST_NAME || ' ' || CUSTOMERS.LAST_NAME AS FULL_NAME,
        COUNT(*) AS NUMBER_OF_ORDERS
    FROM ORDERS
    LEFT JOIN CUSTOMERS ON ORDERS.CUSTOMER_ID = CUSTOMERS.ID
    GROUP BY 1, 2
    ORDER BY 3 DESC
    LIMIT 20
)

SELECT * FROM FINAL
