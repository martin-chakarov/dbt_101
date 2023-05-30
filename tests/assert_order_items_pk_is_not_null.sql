WITH SOURCE_DATA AS (
    SELECT
        *,
        ORDER_ID || ORDER_ITEM_ID AS PK
    FROM {{ source('grocery_store', 'order_items') }}
)

SELECT
    *
FROM SOURCE_DATA
WHERE PK IS NULL
