{{
    config(
        materialized='table'
    )
}}

select
    product_sku,
    product_name,
    count(distinct transaction_id) as total_transactions,
    sum(amount) as total_amount,
    avg(amount) as average_amount
from {{ ref('int_store_transactions') }}
group by 1, 2
order by total_transactions desc
limit 10 