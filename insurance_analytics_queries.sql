-- ==============================================================================
-- PORTFOLIO ASSET: COMMERCIAL INSURANCE POLICY COMPARISON & RISK INSIGHTS PLATFORM
-- EXECUTABLE LOGIC LAYER: SQL ANALYTICS QUERIES
-- SYSTEMS DESIGNATION: BACKEND ANALYTICS SUPPORT FOR TABLEAU VISUALS
-- ==============================================================================

-- ==============================================================================
-- QUERY 1: POLICY COMPARISON TURNAROUND SCORECARD
-- Business Context: Calculates policy comparison processing time and SLA compliance.
-- ==============================================================================
WITH ComparisonSLAIntervals AS (
    SELECT
        comparison_id,
        comparison_started_at,
        comparison_completed_at,
        EXTRACT(
            EPOCH FROM (comparison_completed_at - comparison_started_at)
        ) / 3600.0 AS comparison_turnaround_hours
    FROM PolicyComparisons
    WHERE comparison_status = 'Completed'
      AND comparison_started_at IS NOT NULL
      AND comparison_completed_at IS NOT NULL
)
SELECT
    COUNT(comparison_id) AS total_comparisons_completed,
    ROUND(AVG(comparison_turnaround_hours), 2) AS average_comparison_turnaround_hours,
    FROM ComparisonSLAIntervals;

-- ==============================================================================
-- QUERY 2: COVERAGE EXCLUSION DENSITY ANALYSIS
-- Business Context: Analyzes exclusion frequency and severity across insurers and policy types.
-- ==============================================================================
SELECT 
    p.underwriter_carrier,
    p.policy_type,
    e.unmitigated_risk_severity,
    COUNT(e.exclusion_id) AS total_exclusion_count,
    DENSE_RANK() OVER (
        PARTITION BY p.policy_type 
        ORDER BY COUNT(e.exclusion_id) DESC
    ) AS carrier_risk_density_rank
FROM InsurancePolicies p
LEFT JOIN PolicyExclusions e ON p.policy_id = e.policy_id
GROUP BY p.underwriter_carrier, p.policy_type
ORDER BY p.policy_type, carrier_risk_density_rank;


-- ==============================================================================
-- QUERY 3: ADVISORY AUDIT ACTIVITY LEDGER
-- Business Context: Provides an auditable record of key policy processing and advisory actions.
-- ==============================================================================
SELECT
    a.audit_id,
    a.entity_type,
    a.entity_id,
    a.action,
    a.performed_by,
    a.action_timestamp
FROM AdvisoryAuditLogs a
ORDER BY a.action_timestamp ASC;


-- ==============================================================================
-- QUERY 4: BROKER PRODUCTIVITY & COMPARISON ACTIVITY
-- Business Context: Measures policy comparison activity by broker.
-- ==============================================================================
SELECT
broker_user_id,
    COUNT(comparison_id) AS total_comparisons,  COUNT( CASE WHEN comparison_status = 'Completed' THEN 1  END ) AS completed_comparisons,
     COUNT(CASE WHEN comparison_status = 'Pending' THEN 1  END ) AS pending_comparisons
FROM PolicyComparisons
GROUP BY broker_user_id
ORDER BY total_comparisons DESC;

-- ==============================================================================
-- QUERY 5: RECOMMENDATION TURNAROUND ANALYSIS
-- Business Context: Measures the time required to complete broker recommendations.
-- ==============================================================================
SELECT
    recommendation_id,
    recommendation_version,
    comparison_id,
    recommendation_status,
    recommendation_started_at,
    recommendation_completed_at,
 ROUND( EXTRACT( EPOCH FROM (recommendation_completed_at - recommendation_started_at)) / 3600.0, 2) AS recommendation_turnaround_hours
FROM Recommendations
WHERE recommendation_started_at IS NOT NULL
  AND recommendation_completed_at IS NOT NULL
ORDER BY recommendation_completed_at;
