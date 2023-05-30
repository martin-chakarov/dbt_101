WITH SOURCE_DATA AS (
    SELECT
        *
    FROM {{ source('grocery_store', 'order_items') }}
),

FINAL AS (
    SELECT
        ORDER_ID::INT AS ORDER_ID,
        ORDER_ITEM_ID::INT AS ORDER_ITEM_ID,
        PRODUCT_ID::INT AS PRODUCT_ID,
        QUANTITY::INT AS QUANTITY
    FROM SOURCE_DATA
)

SELECT * FROM FINAL
