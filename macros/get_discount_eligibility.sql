{% macro get_discount_eligibility(total_amount_spent, order_count) %}
  CASE 
    WHEN {{ total_amount_spent }} > 300 OR {{ order_count }} >= 3 THEN TRUE
    ELSE FALSE
  END
{% endmacro %}
