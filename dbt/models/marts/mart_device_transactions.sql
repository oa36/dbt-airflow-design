{{
    config(
        materialized='table'
    )
}}

with device_stats as (
    select
        device_type,
        count(distinct transaction_id) as transaction_count
    from {{ ref('int_store_transactions') }}
    group by 1
),

total_transactions as (
    select
        count(distinct transaction_id) as total_count
    from {{ ref('int_store_transactions') }}
)

select
    device_type,
    transaction_count,
    round(100.0 * transaction_count / total_count, 2) as transaction_percentage
from device_stats
cross join total_transactions
order by transaction_count desc 