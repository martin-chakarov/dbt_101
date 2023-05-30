with order_items as (
    select * from {{ ref('stg_order_items') }}
),

failing as (
    select
        *
    from order_items
    where quantity <= 0
)

select * from failing
