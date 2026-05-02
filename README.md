# TPC-H dbt Showcase

A production-style analytics engineering project built with dbt and BigQuery.
It transforms raw TPC-H supply chain data into a clean star schema ready for analytics.

---

## Project Structure

```
models/
├── staging/          # 1:1 with source tables. Renamed and typed only.
├── intermediate/     # Joined and enriched models. Business logic lives here.
└── marts/
    └── core/         # Final dimension and fact tables for analytics consumption.
```

---

## Data Model

### Sources (seeds)

| Table | Description |
|---|---|
| orders | Order headers with status, dates, and totals |
| lineitem | Individual line items per order |
| customer | Customer info including market segment |
| supplier | Supplier info and account balances |
| part | Part catalog with brand and type |

### Staging

| Model | Description |
|---|---|
| stg_orders | Cleaned orders with renamed columns |
| stg_customers | Cleaned customers with renamed columns |
| stg_lineitems | Cleaned line items with renamed columns |
| stg_suppliers | Cleaned suppliers with renamed columns |
| stg_parts | Cleaned parts with renamed columns |

### Intermediate

| Model | Description |
|---|---|
| int_order_items_enriched | Joins orders, lineitems, suppliers and parts. Calculates net and gross price. |

### Marts

| Model | Type | Description |
|---|---|---|
| dim_customers | table | One row per customer |
| dim_parts | table | One row per part |
| fct_orders | table | One row per order with aggregated line item totals |
| fct_order_items | table | One row per line item with pricing calculations |

---

## Design Decisions

**Staging = views, Marts = tables.**
Staging models are cheap pass-throughs so they stay as views.
Mart models are queried heavily so they are materialized as tables for performance.

**Seeds instead of public dataset.**
TPC-H sample data is loaded via dbt seeds to keep the project self-contained
and runnable without any external data dependencies.

**ref() everywhere.**
All inter-model dependencies use dbt's ref() function so the DAG is
fully tracked and models always run in the correct order.

---

## How to Run

1. Clone this repo
2. Set up a BigQuery project and service account
3. Configure your dbt profile
4. Run:

```bash
dbt deps
dbt seed
dbt build
```

---

## Tech Stack

- **dbt Cloud** — transformation and orchestration
- **BigQuery** — data warehouse
- **dbt-utils** — surrogate keys and testing utilities
- **GitHub** — version control with branch-based workflow