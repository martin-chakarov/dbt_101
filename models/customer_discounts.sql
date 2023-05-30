with customers_overview as (
    select * from {{ ref('customers_overview') }}
), 

final as (
    select
        customer_id,
        number_of_orders,
        total_amount_spent,
        {{ get_discount_eligibility('total_amount_spent','number_of_orders')}} AS IS_ELIGIBLE_FOR_DISCOUNT,
        {{ calculate_discount('total_amount_spent','number_of_orders')}} AS DISCOUNT_USD
    from customers_overview
)

select * from final
