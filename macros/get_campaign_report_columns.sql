{% macro get_campaign_report_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "account_id", "datatype": dbt_utils.type_string()},
    {"name": "billed_charge_local_micro", "datatype": dbt_utils.type_int()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "clicks", "datatype": dbt_utils.type_int()},
    {"name": "date", "datatype": dbt_utils.type_timestamp()},
    {"name": "impressions", "datatype": dbt_utils.type_int()},
    {"name": "url_clicks", "datatype": dbt_utils.type_int()}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('twitter_ads__campaign_report_passthrough_metrics')) }}

{{ return(columns) }}

{% endmacro %}
