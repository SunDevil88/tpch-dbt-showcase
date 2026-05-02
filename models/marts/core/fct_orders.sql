{{
    config(
        materialized='table'
    )
}}

with orders as (

    select * from {{ ref('stg_orders') }}

),

lineitems as (

    select * from {{ ref('stg_lineitems') }}

),

order_summary as (

    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.status_code,
        o.priority,
        o.clerk,
        count(l.line_number)                    as total_line_items,
        sum(l.quantity)                         as total_quantity,
        sum(l.extended_price)                   as total_extended_price,
        sum(round(l.extended_price * (1 - l.discount), 2))   as total_net_price,
        sum(round(l.extended_price * (1 - l.discount) * (1 + l.tax), 2)) as total_gross_price

    from orders o
    inner join lineitems l on o.order_id = l.order_id


    group by 1, 2, 3, 4, 5, 6

)

select * from order_summary