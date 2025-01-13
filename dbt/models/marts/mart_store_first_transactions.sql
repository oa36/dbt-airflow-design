{{
    config(
        materialized='table'
    )
}}

with ranked_transactions as (
    select
        store_id,
        store_name,
        timestamp,
        row_number() over (partition by store_id order by timestamp) as tx_rank
    from {{ ref('int_store_transactions') }}
),

first_and_fifth as (
    select
        store_id,
        store_name,
        min(case when tx_rank = 1 then timestamp end) as first_tx_time,
        min(case when tx_rank = 5 then timestamp end) as fifth_tx_time
    from ranked_transactions
    where tx_rank <= 5
    group by 1, 2
    having count(*) >= 5
)

select
    store_id,
    store_name,
    first_tx_time,
    fifth_tx_time,
    extract(epoch from (fifth_tx_time - first_tx_time))/3600 as hours_to_fifth_transaction
from first_and_fifth 