{% set day_names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'] %}

WITH ORDERS_DATA AS (
    SELECT
        *
    FROM {{ ref('stg_orders') }}
),

ORDERS_BY_DAY_OF_WEEK AS (
    SELECT
        ID,
        DAYNAME(DATE) AS DAY_NAME
    FROM ORDERS_DATA
),

ORDERS_SEPARATED_BY_DAY AS (
    SELECT
    {% for day in day_names %}

        SUM(CASE WHEN DAY_NAME = '{{ day }}' THEN 1 ELSE 0 END) AS ORDER_COUNT_{{day}}

        {%- if not loop.last -%}
        ,
        {%- endif -%}

    {% endfor %}
    FROM ORDERS_BY_DAY_OF_WEEK
)

SELECT * FROM ORDERS_SEPARATED_BY_DAY
