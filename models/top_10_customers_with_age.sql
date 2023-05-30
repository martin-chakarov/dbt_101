WITH TOP_10_CUSTOMERS AS (
    SELECT
        *
    FROM {{ ref("top_10_customers") }}
),

DOB_DATA AS (
    SELECT
        ID,
        DATE_OF_BIRTH
    FROM {{ ref("stg_customers") }}
),

TOP_10_CUSTOMERS_WITH_DOB AS (
    SELECT
        a.*,
        b.date_of_birth
    FROM TOP_10_CUSTOMERS a
    LEFT JOIN DOB_DATA b
    ON a.CUSTOMER_ID = b.ID
),

FINAL AS (
    SELECT
        CUSTOMER_ID, 
        FULL_NAME, 
        ORDER_COUNT, 
        TOTAL_AMOUNT_SPENT, 
        FIRST_ORDER_DATE, 
        LAST_ORDER_DATE,
        {{ calculate_age('DATE_OF_BIRTH') }} AS AGE
    FROM TOP_10_CUSTOMERS_WITH_DOB
)

SELECT 
    * 
FROM FINAL
ORDER BY TOTAL_AMOUNT_SPENT DESC
