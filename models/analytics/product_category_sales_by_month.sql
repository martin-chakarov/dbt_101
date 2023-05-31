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
    select 
        *, 
        left(date_trunc(month, date)::string, 7) as month
    from orders
    where status <> 'cancelled'
    order by 1 desc
),

orders_with_products as (
    select distinct
        orders_filtered.month,
        products.category as product_category,
        sum(order_items.quantity) over (partition by month, product_category) as total_units_sold,
        sum(order_items.quantity * products.price) over (partition by month, product_category) as total_sales_usd
    from orders_filtered
    left join order_items
    on orders_filtered.id = order_items.order_id
    left join products
    on products.id = order_items.product_id
    where order_items.order_item_id is not null
),

final as (
    select
        month,
        product_category as category,
        total_units_sold,
        to_number(total_sales_usd, 10, 2) as total_sales_usd
    from orders_with_products
)

select * from final
order by month desc