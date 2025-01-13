with transactions as (
    select * from {{ ref('stg_transactions') }}
),

stores as (
    select * from {{ ref('stg_stores') }}
),

final as (
    select
        t.transaction_id,
        t.device_id,
        s.store_id,
        s.store_name,
        s.store_type,
        t.product_name,
        t.product_sku,
        t.category_name,
        t.amount,
        t.status,
        t.happened_at,
        t.created_at
    from transactions t
    left join stores s on t.device_id = s.store_id
)

select * from final 