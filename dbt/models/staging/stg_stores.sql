{{
    config(
        materialized='table'
    )
}}

with source as (
    select * from {{ source('crm', 'stores') }}
)

select
    id as store_id,
    name as store_name,
    city as location
from source 