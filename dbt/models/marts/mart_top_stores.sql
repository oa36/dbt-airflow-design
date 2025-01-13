{{
    config(
        materialized='table'
    )
}}

select
    store_id,
    store_name,
    address,
    city,
    country,
    count(distinct transaction_id) as total_transactions,
    sum(amount) as total_amount
from {{ ref('int_store_transactions') }}
group by 1, 2, 3, 4, 5
order by total_amount desc
limit 10 