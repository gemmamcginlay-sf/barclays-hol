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

## Data Model

The lab uses a realistic UK payments data model with 9 tables across reference data, entity data, and transactional data. See [`docs/data_sources.md`](docs/data_sources.md) for the full ERD, source system inventory, and column dictionary.

### Entity chain
```
RELATIONSHIP_MANAGERS → CUSTOMERS → ACCOUNTS → PAYMENTS
                                              ↗ ERROR_CODES
                                              ↗ PAYMENT_SCHEMES
CUSTOMERS → CUSTOMER_FEEDBACK ←→ PAYMENTS
PAYMENTS ←→ OPERATIONAL_ALERTS
PAYMENT_SCHEMES → SLA_DEFINITIONS
```

## Lab Structure

| Step | Topic | Time | Key Files |
|------|-------|------|-----------|
| 1 | Environment Setup | 5 min | `sql/01_setup.sql` |
| 2 | Load Payments Data | 10 min | `sql/02_load_data.sql` |
| 3a | Build dbt Layer (walkthrough) | 15 min | `sql/03_validate_dbt.sql`, `dbt/` |
| 3b | Accelerate with Cortex Code | 10 min | CoCo builds 2 new marts |
| 4 | Cortex AI Enrichment + Dynamic Tables | 20 min | `sql/04_cortex_ai.ipynb` |
| 5 | Snowflake CoWork (Cortex Analyst) | 15 min | `sql/05_intelligence.sql` |
| 6 | Document & Describe | 10 min | `sql/06_documentation.sql` |

## What You'll Build

- **Batch layer (dbt)** — Governed, tested KPI marts scaffolded and deployed by Cortex Code
  - Base models: staging (payments, feedback, customers, accounts) + marts (KPIs, SLA compliance)
  - CoCo-built models: customer payment summary + RM performance dashboard
- **AI layer (Cortex AI)** — Sentiment analysis, topic classification, and LLM-generated alert recommendations enriched with error code context
- **Real-time layer (Dynamic Tables)** — Continuously-refreshing operational views with customer and RM context
- **Natural language analytics (CoWork)** — Semantic Views + Cortex Analyst Agent for plain-English queries across payments, customers, and relationship managers
- **Data Catalog** — Fully documented objects discoverable in Snowsight

## Repo Structure

```
barclays-hol/
├── barclays_hol_data_product.html   # Interactive lab guide (GitHub Pages)
├── docs/
│   └── data_sources.md              # ERD, source systems, column dictionary
├── sql/
│   ├── 01_setup.sql                 # Database, warehouse, schemas
│   ├── 02_load_data.sql             # Load expanded payments data model (9 tables)
│   ├── 03_validate_dbt.sql          # Validation for base + CoCo-built models
│   ├── 04_cortex_ai.ipynb            # Cortex AI + Dynamic Tables (notebook)
│   ├── 05_intelligence.sql          # Analytics views for Semantic Views
│   └── 06_documentation.sql         # COMMENT ON statements
└── dbt/
    ├── dbt_project.yml
    ├── profiles.yml.example
    └── models/
        ├── staging/                  # stg_payments, stg_feedback, stg_customers, stg_accounts
        └── marts/                    # mart_payment_kpis, mart_sla_compliance
                                      # + mart_customer_payments, mart_rm_performance (CoCo-built)
```

## Step 3b: Cortex Code Prompts

After walking through the pre-written dbt models, participants use Cortex Code to build two additional marts:

**Prompt 1 — Customer Payment Summary:**
> "Build a dbt mart called mart_customer_payments that summarises payment activity per customer, including total volume, success rate, and their most-used payment scheme. Join through stg_payments → stg_accounts → stg_customers."

**Prompt 2 — RM Performance Dashboard:**
> "Build a dbt mart called mart_rm_performance showing each relationship manager's portfolio — number of clients, total payment volume, average success rate, and their client with the lowest success rate. Use the existing staging models."

## How to Run

1. **Register** for your Snowflake account using the link above
2. **Open** the [interactive lab guide](https://gemmamcginlay-sf.github.io/barclays-hol/barclays_hol_data_product.html)
3. **Follow** the steps in order — each has inline SQL you copy into Snowsight
4. Companion `.sql` files in `sql/` contain the same code for offline reference

## Disclaimer

All data in this lab is entirely synthetic. No real customer, transaction, or Barclays data is used.
