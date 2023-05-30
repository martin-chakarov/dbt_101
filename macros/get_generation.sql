{% macro get_generation(date_of_birth) %}
  CASE
    WHEN DATE_PART(YEAR, {{ date_of_birth }}) < 1965 THEN 'Baby Boomers'
    WHEN DATE_PART(YEAR, {{ date_of_birth }}) <= 1980 THEN 'Generation X'
    WHEN DATE_PART(YEAR, {{ date_of_birth }}) <= 1996 THEN 'Millennials'
    ELSE 'Generation Z'
  END
{% endmacro %}
