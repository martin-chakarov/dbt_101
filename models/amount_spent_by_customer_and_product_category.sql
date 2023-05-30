{{
  config(
    materialized = 'table',
    )
}}

{% set categories = ['Food', 'Beverages', 'Kitchen Supplies', 'Household Supplies'] %}

with orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    select * from {{ ref('stg_order_items')}}
),

products as (
    select * from {{ ref('stg_products') }}
),

-- filter out cancelled orders
orders_filtered as (
    select 
        orders.customer_id,
        products.category,
        sum(order_items.quantity * products.price) as amount_spent
    from orders
    left join order_items on orders.id = order_items.ORDER_ID
    left join products on order_items.product_id = products.id
    where orders.status <> 'cancelled'
    and order_items.order_id is not null
    group by 1, 2
),

amount_spent_per_category as (
    select
        customer_id,

        {% for category in categories %}
            sum(case when category = '{{category}}' then amount_spent else 0 end) as AMOUNT_SPENT_{{category | replace(' ', '_')}}
            {%- if not loop.last -%}
              ,
            {%- endif -%}
        {% endfor %}
        
    from orders_filtered
    group by 1
)

select * from amount_spent_per_category
