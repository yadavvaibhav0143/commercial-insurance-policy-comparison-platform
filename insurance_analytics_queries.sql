-- ==============================================================================
-- PORTFOLIO ASSET: COMMERCIAL INSURANCE PLACEMENT ENGINE
-- EXECUTABLE LOGIC LAYER: ADVANCED AUDIT BI QUERIES (FULL REPOSITORY SYNC)
-- SYSTEMS DESIGNATION: COMPLETE BACKEND BACKING FOR TABLEAU VISUALS
-- ==============================================================================

-- ==============================================================================
-- QUERY 1: CORE SLA TURNAROUND SCORECARD (Backs the SLA Scorecard Metric Card)
-- Business Context: Calculates overall processing speed and compliance thresholds.
-- ==============================================================================
WITH PlacementSLAIntervals AS (
    SELECT 
        p.policy_id,
        p.underwriter_carrier,
        p.document_upload_timestamp,
        a.action_execution_timestamp AS final_approval_timestamp,
        EXTRACT(EPOCH FROM (a.action_execution_timestamp - p.document_upload_timestamp)) / 3600.0 AS processing_turnaround_hours
    FROM InsurancePolicies p
    JOIN AdvisoryAuditLogs a ON p.policy_id = a.policy_id
    WHERE a.governance_action = 'Advisory_Final_Approve'
)
SELECT 
    COUNT(policy_id) AS total_advisory_portfolios_finalized,
    ROUND(AVG(processing_turnaround_hours), 2) AS average_placement_turnaround_hours,
    COALESCE(
        ROUND((COUNT(CASE WHEN processing_turnaround_hours <= 24.0 THEN 1 END) * 100.0) / NULLIF(COUNT(policy_id), 0), 2),
        100.00
    ) AS branch_sla_compliance_percentage
FROM PlacementSLAIntervals;


-- ==============================================================================
-- QUERY 2: UNMITIGATED LIABILITY EXCLUSION REPORT (Backs the Exclusion Density Chart)
-- Business Context: Uses Window Partitioning to rank and count hidden carrier risks.
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
JOIN PolicyExclusions e ON p.policy_id = e.policy_id
GROUP BY p.underwriter_carrier, p.policy_type, e.unmitigated_risk_severity;


-- ==============================================================================
-- QUERY 3: COMPLIANCE INTEGRITY AUDIT LEDGER (Backs the Audit Ledger Table View)
-- Business Context: Exposes manual overrides and mandatory written justifications.
-- ==============================================================================
SELECT 
    a.operator_username,
    a.governance_action,
    a.action_execution_timestamp,
    a.target_clause_reference,
    COALESCE(a.compliance_override_justification, '🚨 NO OVERRIDE REQUIRED / AUTOMATED RUN') AS audit_line_defensibility
FROM AdvisoryAuditLogs a
ORDER BY a.action_execution_timestamp ASC;


-- ==============================================================================
-- QUERY 4: BROKER PRODUCTIVITY & VELOCITY MONITOR (Future-Proof Scale Metric)
-- Business Context: Counts active transactions processed grouped by analyst teams.
-- ==============================================================================
SELECT 
    a.operator_username,
    COUNT(DISTINCT a.policy_id) AS total_unique_policies_handled,
    COUNT(a.log_id) AS total_governance_actions_logged
FROM AdvisoryAuditLogs a
GROUP BY a.operator_username;
