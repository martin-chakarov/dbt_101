{% set day_names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']%}

SELECT
    {% for day in day_names %}
        SUM(CASE WHEN DAYNAME(DATE) = '{{ day }}' then 1 else 0 END) AS ORDER_COUNT_{{day}}

        {%- if not loop.last %},{% endif %}
    {% endfor %}
FROM {{ ref('stg_orders') }}
