{% macro test_positive_values(model, column_name) %}

  {{ config(severity = 'error') }}

  select
    *
  from {{ model }}
  where {{ column_name }} <= 0
    or {{ column_name }} is null

{% endmacro %}

{% macro test_valid_timestamp(model, column_name) %}

  {{ config(severity = 'error') }}

  select
    *
  from {{ model }}
  where {{ column_name }} > current_timestamp
    or {{ column_name }} < '2000-01-01'::timestamp
    or {{ column_name }} is null

{% endmacro %}

{% macro test_valid_location(model, column_name) %}

  {{ config(severity = 'error') }}

  select
    *
  from {{ model }}
  where {{ column_name }} !~ '^[A-Za-z0-9\s\-\,\.]+$'
    or length({{ column_name }}) > 100
    or {{ column_name }} is null

{% endmacro %} 