with customers as (

    select * from {{ ref('stg_customers') }}

),

final as (

    select
        customer_id,
        customer_name,
        address,
        phone,
        account_balance,
        market_segment

    from customers

)

select * from final