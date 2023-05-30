WITH PIVOTED AS (
    SELECT
        CUSTOMER_ID,
        {{ dbt_utils.pivot('STATUS', dbt_utils.get_column_values(ref('stg_orders'), 'STATUS'), suffix='_ORDERS', quote_identifiers = false) }}
    FROM {{ ref('stg_orders') }}
    GROUP BY CUSTOMER_ID
)

SELECT * FROM PIVOTED
