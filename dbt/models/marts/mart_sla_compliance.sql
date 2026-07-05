-- models/marts/mart_sla_compliance.sql
-- Generated with Cortex Code
-- Daily SLA compliance: joins KPIs against SLA threshold definitions

WITH kpis AS (
    SELECT * FROM {{ ref('mart_payment_kpis') }}
),

sla_defs AS (
    SELECT * FROM {{ source('raw_data', 'sla_definitions') }}
)

SELECT
    k.PAYMENT_DAY,
    k.PAYMENT_TYPE,
    s.SLA_NAME,

    -- Targets
    s.TARGET_SUCCESS_RATE   AS SLA_TARGET_PCT,
    s.MAX_PROCESSING_TIME_MS AS SLA_THRESHOLD_MS,

    -- Actuals
    k.SUCCESS_RATE_PCT      AS ACTUAL_SUCCESS_RATE,
    k.P95_PROCESSING_TIME_MS AS ACTUAL_P95_MS,
    k.TOTAL_PAYMENTS,
    k.FAILED_PAYMENTS,

    -- Compliance verdict
    CASE
        WHEN k.SUCCESS_RATE_PCT   >= s.TARGET_SUCCESS_RATE
         AND k.P95_PROCESSING_TIME_MS <= s.MAX_PROCESSING_TIME_MS THEN 'COMPLIANT'
        WHEN k.SUCCESS_RATE_PCT   >= s.TARGET_SUCCESS_RATE * 0.95  THEN 'AT RISK'
        ELSE 'BREACH'
    END                     AS SLA_STATUS,

    -- Gap metrics
    ROUND(k.SUCCESS_RATE_PCT    - s.TARGET_SUCCESS_RATE,     2) AS RATE_GAP_PCT,
    k.P95_PROCESSING_TIME_MS    - s.MAX_PROCESSING_TIME_MS      AS TIME_GAP_MS

FROM kpis k
JOIN sla_defs s ON k.PAYMENT_TYPE = s.PAYMENT_TYPE
