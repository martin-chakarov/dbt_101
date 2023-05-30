{% macro calculate_discount(total_amount_spent, order_count) %}
  
CASE 
    WHEN NOT IS_ELIGIBLE_FOR_DISCOUNT THEN 0
    WHEN {{ order_count }} <= 3 THEN TO_NUMBER({{total_amount_spent}} * 0.03, 10, 2)
    ELSE TO_NUMBER({{total_amount_spent}} * 0.05, 10, 2)
END
{% endmacro %}
