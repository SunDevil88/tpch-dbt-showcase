with order_items as (

    select * from {{ ref('int_order_items_enriched') }}

),

final as (

    select
        order_id,
        customer_id,
        order_date,
        status_code,
        priority,
        line_number,
        part_id,
        supplier_id,
        part_name,
        brand,
        part_type,
        supplier_name,
        quantity,
        extended_price,
        discount,
        tax,
        net_price,
        gross_price,
        ship_date,
        ship_mode,
        return_flag

    from order_items

)

select * from final