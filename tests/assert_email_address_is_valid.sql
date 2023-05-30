with customers as (
    select * from {{ ref('stg_customers') }}
),

failing as (
    select
        *
    from customers
    where not email regexp '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
)

select * from failing
