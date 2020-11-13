# BigQuery

Useful queries for Google Cloud's BigQuery.

See the [wiki](https://github.com/ElyseAndren/BigQuery/wiki) for walk-throughs (listed below).

***
### [Metadata](https://github.com/ElyseAndren/BigQuery/wiki/Metadata)

  Contains useful BQ queries to look up BQ job history or table/column information.
  
  * Finding Columns/Tables in GCP
  * Finding Attribute Definitions
  * Query History
  * Top Users who hit Table
  * Table create/modification history
  * Who deleted a table
  * Dataset create user
  * List tables in dataset with last access
  * Comparing datatypes of column between different tables
  * Standardized Naming Conventions
  
***
### [User Defined Functions](https://github.com/ElyseAndren/BigQuery/wiki/UDFs)

Contains useful BigQuery [User Defined Functions](https://cloud.google.com/bigquery/docs/reference/standard-sql/user-defined-functions) (UDFs).

* Calculating Interpolated Median
* Programmatically Finding Potential Abbreviations
* Calculating Mortgage Balance
  * Fixed Rate
  * Adjustable Rate
* Subsequent Substrings
* String within String
* Sequential Nodes in Tree
* Character Occurrence Count
  
***
### [Resources Exceeded](https://github.com/ElyseAndren/BigQuery/wiki/Resources-Exceeded)

Unfortunately, BigQuery has scalability issues with analytical functions .
`OVER()` is a non-scalable function in BigQuery which will exceed resources if all of the data cannot fit on a single slot [[1](https://cloud.google.com/bigquery/docs/best-practices-performance-output#use_a_limit_clause_with_large_sorts)], [[2](https://stackoverflow.com/questions/34780543/fixing-resources-exceeded-in-bigquery-and-making-it-run-faster)], [[3](https://stackoverflow.com/questions/46005418/query-failed-error-resources-exceeded-during-query-execution-the-query-could-n)], [[4](https://github.com/ebmdatalab/openprescribing/issues/698)] (which is 1GB), however, we can get around this by partitioning.

This page will walk you through how to get around those scaling errors for these use cases:

* `ROW_NUMBER() OVER()` - assigning random row number
  * This is a helpful resource when wanting to export your data by x-amount of rows
* `ROW_NUMBER() OVER (ORDER BY)` - assign a row number by the ordering of other columns
* `NTILE() OVER(ORDER BY)` - grabbing approximate or exact n-tiles (e.g. decile your data)

***
### [Auto Column Descriptions](https://github.com/ElyseAndren/BigQuery/wiki/Column-Descriptions)

Contains useful functions to automate updating column descriptions in GCP table schemas.
  
* Auto-adding column descriptions in GCP from source
* Transferring column descriptions from source table to destination table

***
### [Slack Alerts](https://github.com/ElyseAndren/BigQuery/wiki/Slack-Alerts)

How to post slack messages from python using input from GCP tables.

* Simple Message
* Message with Attachments
* Attaching Metrics from GCP BigQuery
