WITH PRODUCTS AS (
    SELECT
        *
    FROM {{ ref('stg_products') }}
)

SELECT
    *
FROM PRODUCTS
WHERE PRICE <= 0
