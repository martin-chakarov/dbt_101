{% set categories = ['Food', 'Beverages', 'Kitchen Supplies', 'Household Supplies'] %}
{{
  config(
    materialized = 'table',
    )
}}

with orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

orders_filtered as (
    {% set categories = dbt_utils.get_column_values(table=ref('stg_products'), column='category') %}
    select
        orders.customer_id,

        -- units sold
        {{ aggregate_category_data(categories, 'products.category', 'quantity', alias_suffix='_units_sold') }}

        -- amount_spent
        {{ aggregate_category_data(categories, 'products.category', 'quantity * price', alias_prefix='amount_spent_', is_end_of_select=true) }}

    from orders
    left join order_items on orders.id = order_items.order_id
    left join products on order_items.product_id = products.id
    where orders.status <> 'cancelled'
    group by 1
),

final as (
    select
        customer_id,
        food_units_sold,
        amount_spent_food,
        beverages_units_sold,
        amount_spent_beverages,
        kitchen_supplies_units_sold,
        amount_spent_kitchen_supplies,
        household_supplies_units_sold,
        amount_spent_household_supplies
    from orders_filtered
)

select * from final


