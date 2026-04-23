/* 
   SQL Extraction for Fintech A/B Testing Project
   Goal: Convert raw event logs into a clean, analytical summary table.
   This script demonstrates:
   - JSON Parsing (extracting properties from raw strings)
   - Deduplication (using Window Functions)
   - Multi-table Joins
   - Event-level aggregation
*/

-- 1. Create a cleaned view of events (Deduplication)
WITH deduped_events AS (
    SELECT 
        user_id,
        timestamp,
        event_name,
        properties_json,
        ROW_NUMBER() OVER (
            PARTITION BY user_id, event_name, timestamp 
            ORDER BY event_id
        ) as rn
    FROM raw_events
),
cleaned_events AS (
    SELECT * FROM deduped_events WHERE rn = 1
),

-- 2. Extract specific milestones per user
user_milestones AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_name = 'login' THEN 1 ELSE 0 END) as has_login,
        MAX(CASE WHEN event_name = 'view_dashboard' THEN 1 ELSE 0 END) as has_viewed_dashboard,
        MAX(CASE WHEN event_name = 'click_credit_health' THEN 1 ELSE 0 END) as has_clicked_credit_health,
        MAX(CASE WHEN event_name = 'start_application' THEN 1 ELSE 0 END) as has_started_app,
        MAX(CASE WHEN event_name = 'submit_application' THEN 1 ELSE 0 END) as has_submitted_app
    FROM cleaned_events
    GROUP BY user_id
)

-- 3. Final Analytical Table (User-Level Summary)
SELECT 
    u.user_id,
    u.test_group,
    u.credit_score_bucket,
    u.income_level,
    m.has_login,
    m.has_viewed_dashboard,
    m.has_clicked_credit_health,
    m.has_started_app,
    m.has_submitted_app,
    -- Calculate "Conversion Path" flags
    CASE WHEN m.has_viewed_dashboard = 1 AND m.has_submitted_app = 1 THEN 1 ELSE 0 END as is_converted,
    -- Extract values from JSON if needed (demonstrates tech depth)
    -- Note: Local SQLite uses JSON_EXTRACT, industry SQL (BigQuery/Snowflake) uses similar syntax.
    (SELECT JSON_EXTRACT(properties_json, '$.amount') 
     FROM cleaned_events 
     WHERE user_id = u.user_id AND event_name = 'submit_application' 
     LIMIT 1) as application_amount
FROM users u
LEFT JOIN user_milestones m ON u.user_id = m.user_id;

/*
   RECRUITER NOTE: 
   This transformation is often what differentiates a "data scientist" from a "business analyst."
   Real data doesn't come in a CSV with a 'converted' column; it has to be built from event logs.
*/
