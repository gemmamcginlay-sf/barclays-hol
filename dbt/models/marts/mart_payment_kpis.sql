-- models/marts/mart_payment_kpis.sql
-- Generated with Cortex Code
-- Daily payment KPIs by type and region

WITH payments AS (
    SELECT * FROM {{ ref('stg_payments') }}
)

SELECT
    PAYMENT_DAY,
    PAYMENT_TYPE,
    REGION,

    -- Volume
    COUNT(*)                                                            AS TOTAL_PAYMENTS,
    SUM(AMOUNT)                                                         AS TOTAL_VOLUME_GBP,
    ROUND(AVG(AMOUNT), 2)                                               AS AVG_PAYMENT_AMOUNT,

    -- Outcomes
    COUNT(CASE WHEN IS_SUCCESSFUL THEN 1 END)                           AS SUCCESSFUL_PAYMENTS,
    COUNT(CASE WHEN IS_FAILED     THEN 1 END)                           AS FAILED_PAYMENTS,

    -- Success rate
    ROUND(
        COUNT(CASE WHEN IS_SUCCESSFUL THEN 1 END)::FLOAT / NULLIF(COUNT(*), 0) * 100,
        2
    )                                                                   AS SUCCESS_RATE_PCT,

    -- Processing time
    ROUND(AVG(PROCESSING_TIME_MS), 0)                                   AS AVG_PROCESSING_TIME_MS,
    ROUND(
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY PROCESSING_TIME_MS),
        0
    )                                                                   AS P95_PROCESSING_TIME_MS

FROM payments
GROUP BY PAYMENT_DAY, PAYMENT_TYPE, REGION
