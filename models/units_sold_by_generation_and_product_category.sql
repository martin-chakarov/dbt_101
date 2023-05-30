{{
  config(
    materialized = 'table',
    )
}}

with customers as (
    select * from {{ ref('stg_customers') }}
),

units_sold_per_category as (
    select * from {{ ref('units_sold_by_customer_and_product_category') }}
),

units_sold_with_generation as (
    select
        units_sold_per_category.*,
        {{ get_generation('customers.date_of_birth') }} as generation
    from units_sold_per_category
    left join customers on units_sold_per_category.customer_id = customers.id
),

final as (
    select
        generation,
        sum(food_units_sold) as food_units_sold,
        sum(beverages_units_sold) as beverages_units_sold,
        sum(kitchen_supplies_units_sold) as kitchen_supplies_units_sold,
        sum(household_supplies_units_sold) as household_supplies_units_sold
    from units_sold_with_generation
    group by 1
)

select * from final
