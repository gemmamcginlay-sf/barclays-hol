-- =====================================================
-- BARCLAYS HANDS-ON LAB
-- STEP 2: LOAD PAYMENTS DATA
-- =====================================================

USE WAREHOUSE BARCLAYS_WH;
USE SCHEMA BARCLAYS_HOL.RAW_DATA;

-- 2.1: Payments Transactions
CREATE OR REPLACE TABLE PAYMENTS (
    PAYMENT_ID        VARCHAR(20),
    PAYMENT_DATE      TIMESTAMP,
    ORIGINATOR_NAME   VARCHAR(200),
    BENEFICIARY_NAME  VARCHAR(200),
    PAYMENT_TYPE      VARCHAR(30),
    CHANNEL           VARCHAR(20),
    CURRENCY          VARCHAR(3),
    AMOUNT            NUMBER(15,2),
    STATUS            VARCHAR(20),
    PROCESSING_TIME_MS NUMBER,
    ERROR_CODE        VARCHAR(10),
    REGION            VARCHAR(30)
);

INSERT INTO PAYMENTS
SELECT
    'PAY' || LPAD(SEQ4()::VARCHAR, 10, '0'),
    DATEADD('minute', -UNIFORM(1, 525600, RANDOM()), CURRENT_TIMESTAMP()),
    ARRAY_CONSTRUCT('Acme Corp','Global Trading Ltd','Smith & Partners','Northern Industries',
                    'Atlantic Shipping Co','EuroTech GmbH','Pacific Holdings','Delta Manufacturing')[UNIFORM(0,7,RANDOM())]::VARCHAR,
    ARRAY_CONSTRUCT('Royal Trust PLC','Metro Services Ltd','Crown Logistics','Harbour Finance',
                    'Sterling Solutions','Thames Trading','Oxford Investments','Cambridge Consulting')[UNIFORM(0,7,RANDOM())]::VARCHAR,
    ARRAY_CONSTRUCT('SWIFT','BACS','CHAPS','Faster Payments','SEPA','Wire Transfer')[UNIFORM(0,5,RANDOM())]::VARCHAR,
    ARRAY_CONSTRUCT('API','Online Banking','Branch','File Upload','Mobile')[UNIFORM(0,4,RANDOM())]::VARCHAR,
    ARRAY_CONSTRUCT('GBP','GBP','GBP','EUR','USD')[UNIFORM(0,4,RANDOM())]::VARCHAR,
    ROUND(UNIFORM(100, 5000000, RANDOM())::FLOAT, 2),
    ARRAY_CONSTRUCT('COMPLETED','COMPLETED','COMPLETED','COMPLETED','PENDING','FAILED','RETURNED')[UNIFORM(0,6,RANDOM())]::VARCHAR,
    UNIFORM(50, 30000, RANDOM()),
    CASE WHEN UNIFORM(1,20,RANDOM())=1 THEN 'ERR'||LPAD(UNIFORM(1,50,RANDOM())::VARCHAR,3,'0') ELSE NULL END,
    ARRAY_CONSTRUCT('UK','UK','UK','EMEA','APAC','Americas')[UNIFORM(0,5,RANDOM())]::VARCHAR
FROM TABLE(GENERATOR(ROWCOUNT => 50000));

--Validate Payments Data
SELECT * FROM PAYMENTS LIMIT 10;

-- 2.2: Customer Feedback
CREATE OR REPLACE TABLE CUSTOMER_FEEDBACK (
    FEEDBACK_ID      VARCHAR(15),
    FEEDBACK_DATE    TIMESTAMP,
    CUSTOMER_NAME    VARCHAR(200),
    FEEDBACK_CHANNEL VARCHAR(30),
    FEEDBACK_TEXT    VARCHAR(1000),
    PAYMENT_TYPE     VARCHAR(30),
    RATING           NUMBER(1)
);

INSERT INTO CUSTOMER_FEEDBACK
SELECT
    'FB' || LPAD(SEQ4()::VARCHAR, 8, '0'),
    DATEADD('hour', -UNIFORM(1, 8760, RANDOM()), CURRENT_TIMESTAMP()),
    ARRAY_CONSTRUCT('Acme Corp','Global Trading Ltd','Smith & Partners',
                    'Northern Industries','Atlantic Shipping Co','EuroTech GmbH')[UNIFORM(0,5,RANDOM())]::VARCHAR,
    ARRAY_CONSTRUCT('Email','Phone','Portal','Survey','Chat')[UNIFORM(0,4,RANDOM())]::VARCHAR,
    ARRAY_CONSTRUCT(
        'The SWIFT payment was processed very quickly today. Excellent service as always from the team.',
        'Our BACS payment was delayed by 3 hours which caused issues with our supplier. Very disappointing.',
        'The new API integration for Faster Payments is brilliant. Reduced our processing time significantly.',
        'We experienced an outage during peak hours which resulted in 15 failed payments. This is unacceptable.',
        'The payment tracking dashboard is very helpful. We can now see real-time status of all our transfers.',
        'Customer service was unhelpful when we called about a returned CHAPS payment. Took 45 minutes.',
        'Smooth onboarding for the new payment file format. The documentation was clear and comprehensive.',
        'Multiple payments stuck in pending status for over 24 hours. Our treasury team is extremely frustrated.',
        'The fraud detection system flagged a legitimate payment causing a 2-day delay.',
        'Impressed with the new same-day settlement capability. This has transformed our cash management.',
        'The mobile banking app crashes frequently when approving high-value payments. Needs urgent fix.',
        'Excellent support from the relationship manager. They proactively informed us about the maintenance window.'
    )[UNIFORM(0,11,RANDOM())]::VARCHAR,
    ARRAY_CONSTRUCT('SWIFT','BACS','CHAPS','Faster Payments','SEPA')[UNIFORM(0,4,RANDOM())]::VARCHAR,
    UNIFORM(1, 5, RANDOM())
FROM TABLE(GENERATOR(ROWCOUNT => 2000));

--Validate Customer Feedback Data
SELECT * FROM CUSTOMER_FEEDBACK LIMIT 10;

-- 2.3: SLA Definitions
CREATE OR REPLACE TABLE SLA_DEFINITIONS (
    SLA_ID                  VARCHAR(10),
    SLA_NAME                VARCHAR(100),
    PAYMENT_TYPE            VARCHAR(30),
    MAX_PROCESSING_TIME_MS  NUMBER,
    TARGET_SUCCESS_RATE     NUMBER(5,2),
    MEASUREMENT_WINDOW      VARCHAR(20)
);

INSERT INTO SLA_DEFINITIONS VALUES
('SLA001','CHAPS Same-Day Processing',      'CHAPS',          5000,     99.95,'DAILY'),
('SLA002','Faster Payments Real-Time',      'Faster Payments', 2000,    99.99,'HOURLY'),
('SLA003','BACS Next-Day Settlement',       'BACS',        86400000,    99.90,'DAILY'),
('SLA004','SWIFT International Transfer',  'SWIFT',          60000,    99.50,'DAILY'),
('SLA005','SEPA Euro Transfers',           'SEPA',           30000,    99.80,'DAILY');

--Validate SLA Definitions
SELECT * FROM SLA_DEFINITIONS;

-- 2.4: Operational Alerts
CREATE OR REPLACE TABLE OPERATIONAL_ALERTS (
    ALERT_ID            VARCHAR(15),
    ALERT_TIME          TIMESTAMP,
    SEVERITY            VARCHAR(10),
    PAYMENT_TYPE        VARCHAR(30),
    ALERT_DESCRIPTION   VARCHAR(500),
    STATUS              VARCHAR(20),
    ASSIGNED_TO         VARCHAR(100),
    RESOLUTION_TIME_MIN NUMBER
);

INSERT INTO OPERATIONAL_ALERTS
SELECT
    'ALT' || LPAD(SEQ4()::VARCHAR, 8, '0'),
    DATEADD('minute', -UNIFORM(1, 43200, RANDOM()), CURRENT_TIMESTAMP()),
    ARRAY_CONSTRUCT('LOW','MEDIUM','MEDIUM','HIGH','CRITICAL')[UNIFORM(0,4,RANDOM())]::VARCHAR,
    ARRAY_CONSTRUCT('SWIFT','BACS','CHAPS','Faster Payments','SEPA')[UNIFORM(0,4,RANDOM())]::VARCHAR,
    ARRAY_CONSTRUCT(
        'Processing time exceeded SLA threshold',
        'Elevated failure rate detected',
        'Connectivity issue with clearing house',
        'Unusual transaction volume spike',
        'Settlement file delivery delayed',
        'Duplicate payment detection triggered',
        'Beneficiary validation timeout'
    )[UNIFORM(0,6,RANDOM())]::VARCHAR,
    ARRAY_CONSTRUCT('OPEN','OPEN','ACKNOWLEDGED','INVESTIGATING','RESOLVED','RESOLVED')[UNIFORM(0,5,RANDOM())]::VARCHAR,
    'Ops Team ' || ARRAY_CONSTRUCT('Alpha','Beta','Gamma')[UNIFORM(0,2,RANDOM())]::VARCHAR,
    CASE WHEN UNIFORM(1,3,RANDOM())!=1 THEN UNIFORM(5,480,RANDOM()) ELSE NULL END
FROM TABLE(GENERATOR(ROWCOUNT => 1500));

--Validate Operational Alerts
SELECT * FROM OPERATIONAL_ALERTS LIMIT 10;

-- Verify row counts
SELECT 'PAYMENTS'           AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM PAYMENTS       UNION ALL
SELECT 'CUSTOMER_FEEDBACK',                COUNT(*)               FROM CUSTOMER_FEEDBACK UNION ALL
SELECT 'SLA_DEFINITIONS',                  COUNT(*)               FROM SLA_DEFINITIONS   UNION ALL
SELECT 'OPERATIONAL_ALERTS',               COUNT(*)               FROM OPERATIONAL_ALERTS;
