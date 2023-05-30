-- calculates tip as a percentage of order total

{%- macro calculate_tip(order_total, tip_percentage) -%}

    TO_NUMBER( ( {{order_total}} * {{tip_percentage}} / 100 ), 10, 2 )

{%- endmacro -%}
