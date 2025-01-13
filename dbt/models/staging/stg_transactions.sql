{{
    config(
        materialized='incremental',
        unique_key='transaction_id',
        incremental_strategy='delete+insert'
    )
}}

with source as (
    select * from {{ source('crm', 'transactions') }}
    {% if is_incremental() %}
    where happened_at > (select max(timestamp) from {{ this }})
    {% endif %}
),

devices as (
    select * from {{ source('crm', 'devices') }}
)

select
    s.id as transaction_id,
    d.store_id,
    s.device_id,
    s.product_name,
    s.product_sku,
    s.category_name,
    s.amount,
    s.status,
    s.happened_at as timestamp,
    s.created_at
from source s
inner join devices d on s.device_id = d.id 