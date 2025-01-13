{{
    config(
        materialized='table'
    )
}}

with source as (
    select * from {{ source('crm', 'devices') }}
)

select
    id as device_id,
    store_id,
    type as device_type
from source 