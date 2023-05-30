WITH SOURCE_DATA AS (
    SELECT
        *,
        ORDER_ID || ORDER_ITEM_ID AS PK
    FROM {{ ref('stg_order_items') }}
)

SELECT
    PK,
    COUNT(*) 
FROM SOURCE_DATA
GROUP BY 1
HAVING COUNT(*) > 1
