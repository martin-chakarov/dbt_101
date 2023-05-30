WITH SOURCE_DATA AS (
    SELECT
        *
    FROM {{ source('grocery_store', 'customers') }}
),

FINAL AS (
    SELECT
        ID::INT AS ID,
        FIRST_NAME::STRING AS FIRST_NAME,
        LAST_NAME::STRING AS LAST_NAME,
        EMAIL::STRING AS EMAIL,
        GENDER::STRING AS GENDER,
        DATE_OF_BIRTH::DATE AS DATE_OF_BIRTH
    FROM SOURCE_DATA
)

SELECT * FROM FINAL
