-- ==============================================================================
-- PORTFOLIO ASSET: COMMERCIAL INSURANCE POLICY COMPARISON & RISK INSIGHTS PLATFORM
-- INGESTION LAYER: SAMPLE DATA SEED INITIALIZATION (DML)
-- ==============================================================================

-- 1. Populating Enterprise Corporate Client Accounts
INSERT INTO CorporateClients (client_id, legal_entity_name, industry_sector, account_revenue_tier, risk_appetite_rating) VALUES 
(1, 'TechCorp Global Solutions Private Ltd', 'SaaS & Enterprise IT Services', 'Enterprise', 'Risk-Averse'),
(2, 'Deccan Freight & Logistics Hub', 'Supply Chain, Fleet & Transport', 'Mid-Market', 'Balanced');

-- 2. Populating Insurance Policy Records
INSERT INTO InsurancePolicies (policy_id, client_id, underwriter_carrier, policy_type, annual_premium_amount, document_upload_timestamp, ai_extraction_status) VALUES 
(501, 1, 'Tata AIG General Insurance Co', 'Cyber Liability', 450000.00, '2026-06-25 09:15:00', 'Completed'),
(502, 1, 'HDFC Ergo General Insurance', 'Cyber Liability', 420000.00, '2026-06-25 10:30:00', 'Completed'),
(503, 1, 'ICICI Lombard General Insurance', 'Cyber Liability', 510000.00, '2026-06-25 11:45:00', 'Pending'),
(504, 2, 'Cholamandalam MS Insurance', 'Errors & Omissions', 680000.00, '2026-06-26 14:00:00', 'Completed');

-- 3. Populating Policy Coverage Clauses
INSERT INTO PolicyCoverages (coverage_id, policy_id, contract_clause_reference, coverage_term_raw, normalized_taxonomy_group, aggregate_coverage_limit, inner_sub_limit_cap) VALUES
(701, 501, 'Section 2.1(a)', 'First-Party Incident Response Costs and Forensics', 'Incident_Response', 50000000.00, 5000000.00),
(702, 501, 'Section 2.4(c)', 'Cyber Extortion Ingress Ransom Payments', 'Cyber_Extortion', 50000000.00, 2500000.00),
(703, 502, 'Clause 4.1.A', 'Privacy Network Security Liability & Extortion Loss', 'Cyber_Extortion', 40000000.00, 1000000.00),
(704, 504, 'Schedule 1.2', 'Professional Indemnity Legal Defense Indemnification', 'Legal_Defense', 75000000.00, 0.00);

-- 4. Populating Policy Exclusions
INSERT INTO PolicyExclusions (exclusion_id, policy_id, contract_clause_reference, exclusion_title_raw, unmitigated_risk_severity) VALUES 
(901, 501, 'Section 4.2', 'Losses directly arising from unpatched legacy operating system vulnerabilities', 'Critical'),
(902, 501, 'Section 7.1', 'Social engineering corporate transfer fraud sub-limit regulatory caps', 'Standard'),
(903, 502, 'Section 5.1.4', 'Ransomware network transmission disruption systemic negligence exemptions', 'Critical'),
(904, 504, 'Exclusion 9.2', 'Prior knowledge of retroactive notification billing errors', 'Critical');

-- 5. Populating Policy Comparison Records
INSERT INTO PolicyComparisons (comparison_id, base_policy_id, comparison_policy_id, comparison_date, comparison_status, broker_user_id, comparison_started_at, comparison_completed_at) VALUES
(1001, 501, 502, '2026-06-25', 'Completed', 205, '2026-06-25 12:00:00', '2026-06-25 12:49:00'),
(1002, 501, 503, '2026-06-25', 'Pending', 205, '2026-06-25 12:30:00', NULL);

-- 6. Populating Recommendation Records 
INSERT INTO Recommendations (recommendation_id, comparison_id, recommendation_version, recommendation_type, recommendation_status, recommendation_started_at, recommendation_completed_at) VALUES
(2001, 1001, 1, 'Best Match', 'Approved', '2026-06-25 13:00:00', '2026-06-25 14:00:00');

-- 7. Populating Compliance Audit Trail History & Overrides 
INSERT INTO AdvisoryAuditLogs (audit_id, entity_type, entity_id, action, performed_by, action_timestamp, justification) VALUES
(3001, 'Policy', 501, 'Upload', 'broker_vaibhav_yadav', '2026-06-25 09:20:00', NULL),
(3002, 'Comparison', 1001, 'Compare', 'broker_vaibhav_yadav', '2026-06-25 12:00:00', NULL),
(3003, 'Report', 1001, 'Report Generated', 'broker_vaibhav_yadav', '2026-06-25 12:50:00', NULL),
(3004, 'Recommendation', 2001, 'Manual Override', 'broker_vaibhav_yadav', '2026-06-25 13:30:00', 'Broker validated client-specific risk exposure and adjusted the recommendation.'),
(3005, 'Recommendation', 2001, 'Approved', 'broker_vaibhav_yadav', '2026-06-25 14:00:00', NULL);
