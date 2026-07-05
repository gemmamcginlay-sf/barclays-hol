# Barclays Hands-On Lab — Building a Data Product with Cortex AI

A self-contained Snowflake hands-on lab (~90 min) covering Cortex Code, dbt, Cortex AI, Dynamic Tables, Semantic Views, and Snowflake CoWork.

---

## Interactive Lab Guide

**[Open the full interactive lab guide](https://gemmamcginlay-sf.github.io/barclays-hol/barclays_hol_data_product.html)**

The lab is delivered via a rich HTML guide with step-by-step instructions, copy-paste SQL, and progress tracking. Open it in your browser and follow along.

---

## Prerequisites

- Register for your provisioned Snowflake account: **[Register here](https://go.dataops.live/tech-fest-barclays/register)**
- Modern browser (Chrome, Firefox, Edge) to access Snowsight

## Lab Structure

| Step | Topic | Time | Key Files |
|------|-------|------|-----------|
| 1 | Environment Setup | 5 min | `sql/01_setup.sql` |
| 2 | Load Payments Data | 10 min | `sql/02_load_data.sql` |
| 3 | Build a dbt Layer with Cortex Code | 20 min | `sql/03_validate_dbt.sql`, `dbt/` |
| 4 | Cortex AI Enrichment + Dynamic Tables | 20 min | `sql/04_cortex_ai.sql` |
| 5 | Snowflake CoWork (Cortex Analyst) | 15 min | `sql/05_intelligence.sql` |
| 6 | Document & Describe | 10 min | `sql/06_documentation.sql` |

## What You'll Build

- **Batch layer (dbt)** — Governed, tested KPI marts scaffolded and deployed by Cortex Code
- **AI layer (Cortex AI)** — Sentiment analysis, topic classification, and LLM-generated alert recommendations
- **Real-time layer (Dynamic Tables)** — Continuously-refreshing operational views, no orchestration
- **Natural language analytics (CoWork)** — Semantic View + Cortex Analyst Agent for plain-English queries
- **Data Catalog** — Fully documented objects discoverable in Snowsight

## Repo Structure

```
barclays-hol/
├── barclays_hol_data_product.html   # Interactive lab guide (GitHub Pages)
├── sql/
│   ├── 01_setup.sql                 # Database, warehouse, schemas
│   ├── 02_load_data.sql             # Load synthetic payments data
│   ├── 03_validate_dbt.sql          # Validation script for Cortex Code output
│   ├── 04_cortex_ai.sql             # Cortex AI + Dynamic Tables
│   ├── 05_intelligence.sql          # Analytics view for Semantic View
│   └── 06_documentation.sql         # COMMENT ON statements
└── dbt/
    ├── dbt_project.yml
    ├── profiles.yml.example
    └── models/                      # Expected dbt output (reference)
```

## How to Run

1. **Register** for your Snowflake account using the link above
2. **Open** the [interactive lab guide](https://gemmamcginlay-sf.github.io/barclays-hol/barclays_hol_data_product.html)
3. **Follow** the steps in order — each has inline SQL you copy into Snowsight
4. Companion `.sql` files in `sql/` contain the same code for offline reference

## Disclaimer

All data in this lab is entirely synthetic. No real customer, transaction, or Barclays data is used.
