{% macro generate_schema_name(custom_schema_name, node) -%}

    {% if target.name == 'dev' %}
        dbt_{{ target.user }}
    {% else %}
        {{ custom_schema_name | trim }}
    {% endif %}

{%- endmacro %} 