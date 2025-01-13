with transactions as (
    select * from {{ ref('stg_transactions') }}
),

daily_stats as (
    select
        date_trunc('day', happened_at) as date,
        count(*) as total_transactions,
        count(case when status = 'accepted' then 1 end) as accepted_transactions,
        sum(amount) as total_amount,
        sum(case when status = 'accepted' then amount else 0 end) as accepted_amount
    from transactions
    group by 1
)

select * from daily_stats 