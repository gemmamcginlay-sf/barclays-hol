-- =====================================================
-- BARCLAYS HANDS-ON LAB
-- STEP 5: SNOWFLAKE CoWork
-- Creates the analytics view for the Semantic View
-- Semantic View and Agent are created via Snowsight UI
-- =====================================================

USE WAREHOUSE BARCLAYS_WH;
USE SCHEMA BARCLAYS_HOL.ANALYTICS;

-- 5.1: Consolidated analytics view for the Semantic Model
-- This view is the stable interface the Semantic View will be built on
CREATE OR REPLACE VIEW V_PAYMENTS_ANALYSIS AS
SELECT
    -- Time dimensions
    k.PAYMENT_DATE,
    DATE_TRUNC('WEEK',  k.PAYMENT_DATE)         AS PAYMENT_WEEK,
    DATE_TRUNC('MONTH', k.PAYMENT_DATE)         AS PAYMENT_MONTH,
    YEAR(k.PAYMENT_DATE)                        AS YEAR,
    QUARTER(k.PAYMENT_DATE)                     AS QUARTER,

    -- Business dimensions
    k.PAYMENT_TYPE,
    k.REGION,

    -- Volume metrics
    k.TOTAL_PAYMENTS,
    k.TOTAL_VOLUME,

    -- Performance metrics
    k.SUCCESS_RATE_PCT,
    k.AVG_PROCESSING_TIME_MS,
    k.P95_PROCESSING_TIME_MS

FROM MART_PAYMENT_KPIS k;

-- Verify
SELECT * FROM V_PAYMENTS_ANALYSIS LIMIT 5;

-- 5.2: Verify Semantic View after creating it in Snowsight UI
-- (Run this after completing the UI steps below)
-- SHOW SEMANTIC VIEWS IN SCHEMA BARCLAYS_HOL.ANALYTICS;

-- =====================================================
-- SNOWSIGHT UI STEPS (no SQL required):
--
-- CREATE SEMANTIC VIEW:
--   Data → Databases → BARCLAYS_HOL → ANALYTICS → Views
--   → V_PAYMENTS_ANALYSIS → ⋮ → Create Semantic View
--   OR: AI & ML → Analyst → Semantic Views → Create with Autopilot
--   Name: SV_PAYMENTS_BARCLAYS  |  Schema: ANALYTICS
--
-- CREATE CORTEX AGENT:
--   AI & ML → Agents (or Snowflake CoWork)
--   Name: BARCLAYS_PAYMENTS_ASSISTANT
--   + Query Structured Data → Add Semantic View → Cortex Analyst → SV_PAYMENTS_BARCLAYS
--
-- SAMPLE QUESTIONS TO TRY:
--   "What is the total payment volume this month?"
--   "Which payment type has the lowest success rate?"
--   "Show the trend of CHAPS payments by week"
--   "What is the average processing time for Faster Payments?"
--   "Compare success rates across regions"
-- =====================================================
