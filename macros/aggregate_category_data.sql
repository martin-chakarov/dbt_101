{% macro aggregate_category_data(categories, category_column, aggregate_value, alias_prefix, alias_suffix, is_end_of_select=false)%}

    {% for category in categories %}
        sum(case when {{ category_column }} = '{{category}}' then {{ aggregate_value }} else 0 end) as {{alias_prefix}}{{category | replace(' ', '_')}}{{alias_suffix}}
        {%- if not is_end_of_select -%}
            ,
        {%- elif not loop.last -%}
            ,
        {%- endif -%}
    {% endfor %}

{% endmacro %}
