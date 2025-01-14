{{
    config(
        materialized='table'
    )
}}

select
    typology,
    country,
    count(distinct store_id) as store_count,
    count(distinct transaction_id) as transaction_count,
    round(avg(amount), 2) as average_transaction_amount,
    round(sum(amount), 2) as total_amount
from {{ ref('int_store_transactions') }}
group by 1, 2
order by country, average_transaction_amount desc 