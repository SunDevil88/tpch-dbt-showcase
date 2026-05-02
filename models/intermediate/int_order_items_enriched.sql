with orders as (

    select * from {{ ref('stg_orders') }}

),

lineitems as (

    select * from {{ ref('stg_lineitems') }}

),

suppliers as (

    select * from {{ ref('stg_suppliers') }}

),

parts as (

    select * from {{ ref('stg_parts') }}

),

final as (

    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.status_code,
        o.priority,
        l.line_number,
        l.part_id,
        l.supplier_id,
        l.quantity,
        l.extended_price,
        l.discount,
        l.tax,
        l.ship_date,
        l.ship_mode,
        l.return_flag,
        s.supplier_name,
        s.account_balance as supplier_balance,
        p.part_name,
        p.brand,
        p.part_type,
        p.retail_price,
        round(l.extended_price * (1 - l.discount), 2) as net_price,
        round(l.extended_price * (1 - l.discount) * (1 + l.tax), 2) as gross_price

    from orders o
    inner join lineitems l on o.order_id = l.order_id
    inner join suppliers s on l.supplier_id = s.supplier_id
    inner join parts p on l.part_id = p.part_id

)

select * from final