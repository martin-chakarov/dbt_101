WITH ORDER_DATA AS (
    SELECT
        *
    FROM {{ ref('stg_orders') }}
),

PIVOTED_DATA AS (
    SELECT
        CUSTOMER_ID,
        {{ dbt_utils.pivot('STATUS', dbt_utils.get_column_values(ref('stg_orders'), 'STATUS'), suffix='_ORDERS', quote_identifiers = false) }}
    FROM ORDER_DATA
    GROUP BY 1
)

SELECT * FROM PIVOTED_DATA
