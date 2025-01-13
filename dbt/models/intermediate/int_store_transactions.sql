{{
    config(
        materialized='table'
    )
}}

with store_devices as (
    select
        s.store_id,
        s.store_name,
        s.address,
        s.city,
        s.country,
        d.device_id,
        d.device_type
    from {{ ref('stg_stores') }} s
    left join {{ ref('stg_devices') }} d
    on s.store_id = d.store_id
),

final as (
    select
        t.transaction_id,
        t.timestamp,
        t.amount,
        sd.store_id,
        sd.store_name,
        sd.address,
        sd.city,
        sd.country,
        sd.device_id,
        sd.device_type
    from {{ ref('stg_transactions') }} t
    inner join store_devices sd
    on t.device_id = sd.device_id
)

select * from final 