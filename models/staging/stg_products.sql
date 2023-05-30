WITH SOURCE_DATA AS (
    SELECT
        *
    FROM {{ source('grocery_store', 'products') }}
),

FINAL AS (
    SELECT
        ID::INT AS ID,
        NAME::STRING AS NAME,
        PRICE::FLOAT AS PRICE,
        CATEGORY::STRING AS CATEGORY
    FROM SOURCE_DATA
)

SELECT * FROM FINAL
