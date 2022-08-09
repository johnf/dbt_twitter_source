<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_twitter_source/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.0.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Twitter Ads Source dbt Package ([Docs](https://fivetran.github.io/dbt_twitter_source/))

# 📣 What does this dbt package do?
- Materializes [Twitter Ads staging tables](https://fivetran.github.io/dbt_twitter_source/#!/overview/twitter_source/models/?g_v=1&g_e=seeds) which leverage data in the format described by [this ERD](https://fivetran.com/docs/applications/twitter-ads#schemainformation). These staging tables clean, test, and prepare your Twitter Ads data from [Fivetran's connector](https://fivetran.com/docs/applications/twitter-ads) for analysis by doing the following:
  - Name columns for consistency across all packages and for easier analysis
  - Adds freshness tests to source data
  - Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Generates a comprehensive data dictionary of your Twitter Ads data through the [dbt docs site](https://fivetran.github.io/dbt_twitter_source/).
- These tables are designed to work simultaneously with our [Twitter Ads transformation package](https://github.com/fivetran/dbt_twitter).

# 🎯 How do I use the dbt package?
## Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran Twitter Ads connector syncing data into your destination. 
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

## Step 2: Install the package
Include the following twitter_source package version in your `packages.yml` file.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yml
# packages.yml
packages:
  - package: fivetran/twitter_source
    version: [">=0.5.0", "<0.6.0"]
```

## Step 3: Define database and schema variables
By default, this package runs using your destination and the `twitter_ads` schema. If this is not where your Twitter Ads data is (for example, if your twitter schema is named `twitter_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
# dbt_project.yml
vars:
    twitter_ads_schema: your_schema_name
    twitter_ads_database: your_destination_name 
```

### Step 4: Disabling Keyword Models
This package takes into consideration that not every Twitter Ads account tracks `keyword` performance, and allows you to disable the corresponding functionality by adding the following variable configuration:
```yml
# dbt_project.yml
vars:
    twitter_ads__using_keywords: False # Default = true
```

## (Optional) Step 5: Additional configurations
### Passing Through Additional Metrics
By default, this package will select `clicks`, `impressions`, and `cost` from `_report` source tables used by the respective staging models. If you would like to pass through additional metrics to the staging models, add the variable configuration in the code block below to your `dbt_project.yml` file. These variables allow for the pass-through fields to be aliased (`alias`) and casted (`transform_sql`) if desired, but not required. Datatype casting is configured via a sql snippet within the `transform_sql` key. You may add the desired sql while omitting the `as field_name` at the end and your custom pass-though fields will be casted accordingly. Use the below format for declaring the respective pass-through variables:

```yml
# dbt_project.yml
vars:
    twitter_ads__campaign_report_passthrough_metrics: 
        - name: "new_custom_field"
          alias: "custom_field"
    twitter_ads__line_item_report_passthrough_metrics: 
        - name: "unique_int_field"
          alias: "field_id"
          transform_sql: "cast(field_id as int)"
    twitter_ads__line_item_keywords_report_passthrough_metrics: 
        - name: "that_field"
    twitter_ads__promoted_tweet_report_passthrough_metrics: 
        - name: "that_field"
          transform_sql: "that_field / 100.0"
```

### Change the build schema
By default, this package builds the Twitter Ads staging models within a schema titled (`<target_schema>` + `_twitter_ads_source`) in your destination. If this is not where you would like your Twitter staging data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
# dbt_project.yml
models:
    twitter_ads_source:
        +schema: my_new_schema_name # leave blank for just the target_schema
```

### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_twitter_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
# dbt_project.yml
vars:
    twitter_ads_<default_source_table_name>_identifier: your_table_name 
```

## (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.3.0", "<0.4.0"]
    - package: dbt-labs/dbt_utils
      version: [">=0.8.0", "<0.9.0"]
```

# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend that you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/twitter_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_twitter_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions!

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_twitter_source/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [on Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com.