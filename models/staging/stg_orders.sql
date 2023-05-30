WITH SOURCE_DATA AS (
    SELECT
        *
    FROM {{ source('grocery_store', 'orders') }}
),

FINAL AS (
    SELECT
        ID::INT AS ID,
        DATE::DATE AS DATE,
        CUSTOMER_ID::INT AS CUSTOMER_ID,
        STATUS::VARCHAR AS STATUS
    FROM SOURCE_DATA
)

SELECT * FROM FINAL
