{{ config(materialized = 'view') }}

WITH CUSTOMERS_DATA AS (
    SELECT
        *
    FROM {{ ref('stg_customers') }}
),

FINAL AS (
    SELECT
        *,
        {{calculate_age('DATE_OF_BIRTH')}} AS AGE
        FROM CUSTOMERS_DATA
)

SELECT * FROM FINAL
