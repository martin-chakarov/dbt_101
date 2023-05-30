{%- macro calculate_age(date_of_birth) -%}

CASE
    WHEN DATE_PART(DAY, {{ date_of_birth }}) <= DATE_PART(DAY, CURRENT_TIMESTAMP)
    AND DATE_PART(MONTH, {{ date_of_birth }}) <= DATE_PART(MONTH, CURRENT_TIMESTAMP)
    THEN DATEDIFF(YEAR, {{ date_of_birth }}, CURRENT_TIMESTAMP)
    ELSE DATEDIFF(YEAR, {{ date_of_birth }}, CURRENT_TIMESTAMP) - 1
END 

{%- endmacro -%}
