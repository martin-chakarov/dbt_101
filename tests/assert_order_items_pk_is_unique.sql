WITH SOURCE_DATA AS (
    SELECT
        *,
        ORDER_ID || ORDER_ITEM_ID AS PK
    FROM {{ source('grocery_store', 'order_items') }}
)

SELECT
    PK,
    COUNT(*) 
FROM SOURCE_DATA
GROUP BY 1
HAVING COUNT(*) > 1
