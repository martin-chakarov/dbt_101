WITH SOURCE_DATA AS (
    SELECT * FROM {{ source('grocery_store', 'customers') }}
),

STAGING_DATA AS (
    SELECT * FROM {{ ref('stg_customers') }}
)

SELECT
    *
FROM SOURCE_DATA

EXCEPT

SELECT
    *
FROM STAGING_DATA
