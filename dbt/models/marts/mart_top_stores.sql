{{
    config(
        materialized='table'
    )
}}

select
    store_id,
    store_name,
    count(distinct transaction_id) as total_transactions,
    sum(amount) as total_amount
from {{ ref('int_store_transactions') }}
group by 1, 2
order by total_amount desc