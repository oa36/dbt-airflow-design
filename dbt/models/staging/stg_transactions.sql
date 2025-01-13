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
)

select
    id as transaction_id,
    device_id,
    amount,
    happened_at as timestamp
from source 