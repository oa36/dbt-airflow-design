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
        s.typology,
        s.customer_id,
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
        t.product_name,
        t.product_sku,
        t.category_name,
        sd.store_id,
        sd.store_name,
        sd.address,
        sd.city,
        sd.country,
        sd.device_id,
        sd.device_type,
        sd.typology,
        sd.customer_id
    from {{ ref('stg_transactions') }} t
    inner join store_devices sd
    on t.device_id = sd.device_id
)

select * from final 