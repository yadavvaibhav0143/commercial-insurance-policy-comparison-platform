-- ==============================================================================
-- PORTFOLIO ASSET: COMMERCIAL INSURANCE PLACEMENT ENGINE
-- EXECUTABLE LOGIC LAYER: ADVANCED AUDIT BI QUERIES
-- SYSTEMS DESIGNATION: REVENUE DATA EXTRACTION & SYSTEMIC RISK ISOLATION
-- ==============================================================================

-- ==============================================================================
-- QUERY 1: CORE BROKERAGE PLACEMENT PROCESSING SLA VELOCITY LOGS
-- Business Context: Maps Slide 19 operational speed metrics.
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
    -- Fixed: Full division-by-zero protective formula loop intact
    COALESCE(
        ROUND((COUNT(CASE WHEN processing_turnaround_hours <= 24.0 THEN 1 END) * 100.0) / NULLIF(COUNT(policy_id), 0), 2),
        100.00
    ) AS branch_sla_compliance_percentage
FROM PlacementSLAIntervals;


-- ==============================================================================
-- QUERY 2: UNMITIGATED LIABILITY & COVERAGE GAP RANKING REPORT
-- Business Context: Maps Slide 21 E&O Risk Isolation and Carrier Exclusions.
-- ==============================================================================
SELECT 
    p.underwriter_carrier,
    p.policy_type,
    e.contract_clause_reference,
    e.exclusion_title_raw,
    e.unmitigated_risk_severity,
    COALESCE(a.compliance_override_justification, 'No advisory mitigation recorded') AS audit_line_defensibility,
    -- Advanced Window Partition to stack and rank carrier liabilities
    DENSE_RANK() OVER (
        PARTITION BY p.policy_type 
        ORDER BY CASE e.unmitigated_risk_severity WHEN 'Critical' THEN 1 WHEN 'Standard' THEN 2 ELSE 3 END ASC
    ) AS carrier_risk_priority_rank
FROM InsurancePolicies p
JOIN PolicyExclusions e ON p.policy_id = e.policy_id
LEFT JOIN AdvisoryAuditLogs a ON p.policy_id = a.policy_id AND e.contract_clause_reference = a.target_clause_reference;
