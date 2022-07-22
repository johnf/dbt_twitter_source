
with base as (

    select * 
    from {{ ref('stg_twitter__account_report_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_twitter__account_report_tmp')),
                staging_columns=get_account_report_columns()
            )
        }}
    from base
),

final as (
    
    select 
        date as date_day,
        account_id,
        {# engagements,
        follows, #}
        impressions -- see if this ties out
        {# likes,
        replies,
        retweets,
        unfollows #}

    from fields
)

select *
from final
