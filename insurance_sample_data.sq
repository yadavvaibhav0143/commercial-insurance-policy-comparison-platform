-- ==============================================================================
-- PORTFOLIO ASSET: COMMERCIAL INSURANCE PLACEMENT ENGINE
-- INGESTION LAYER: PRODUCTION-GRADE SEED INITIALIZATION DATA (DML)
-- SYSTEMS DESIGNATION: HIGH-CONCURRENCY MOCK DATA VALIDATION RUN
-- ==============================================================================

-- 1. Populating Enterprise Corporate Client Accounts
INSERT INTO CorporateClients (client_id, legal_entity_name, industry_sector, account_revenue_tier, risk_appetite_rating) VALUES 
(1, 'TechCorp Global Solutions Private Ltd', 'SaaS & Enterprise IT Services', 'Enterprise', 'Risk-Averse'),
(2, 'Deccan Freight & Logistics Hub', 'Supply Chain, Fleet & Transport', 'Mid-Market', 'Balanced');

-- 2. Populating Competing Underwriter Carrier Quote Submissions
INSERT INTO InsurancePolicies (policy_id, client_id, underwriter_carrier, policy_type, annual_premium_amount, document_upload_timestamp, ai_extraction_status) VALUES 
(501, 1, 'Tata AIG General Insurance Co', 'Cyber Liability', 450000.00, '2026-06-25 09:15:00', 'Completed'),
(502, 1, 'HDFC Ergo General Insurance', 'Cyber Liability', 420000.00, '2026-06-25 10:30:00', 'Completed'),
(503, 1, 'ICICI Lombard General Insurance', 'Cyber Liability', 510000.00, '2026-06-25 11:45:00', 'Pending'),
(504, 2, 'Cholamandalam MS Insurance', 'Errors & Omissions', 680000.00, '2026-06-26 14:00:00', 'Completed');

-- 3. Populating Extracted Policy Coverage Clauses (Side-by-Side Ingress Models)
INSERT INTO PolicyCoverages (coverage_id, policy_id, contract_clause_reference, coverage_term_raw, normalized_taxonomy_group, aggregate_coverage_limit, inner_sub_limit_cap) VALUES
(701, 501, 'Section 2.1(a)', 'First-Party Incident Response Costs and Forensics', 'Incident_Response', 50000000.00, 5000000.00),
(702, 501, 'Section 2.4(c)', 'Cyber Extortion Ingress Ransom Payments', 'Cyber_Extortion', 50000000.00, 2500000.00),
(703, 502, 'Clause 4.1.A', 'Privacy Network Security Liability & Extortion Loss', 'Cyber_Extortion', 40000000.00, 1000000.00),
(704, 504, 'Schedule 1.2', 'Professional Indemnity Legal Defense Indemnification', 'Legal_Defense', 75000000.00, 0.00);

-- 4. Populating Hidden Carrier Policy Exclusions (The Core E&O Risk Indicators)
INSERT INTO PolicyExclusions (exclusion_id, policy_id, contract_clause_reference, exclusion_title_raw, unmitigated_risk_severity) VALUES 
(901, 501, 'Section 4.2', 'Losses directly arising from unpatched legacy operating system vulnerabilities', 'Critical'),
(902, 501, 'Section 7.1', 'Social engineering corporate transfer fraud sub-limit regulatory caps', 'Standard'),
(903, 502, 'Section 5.1.4', 'Ransomware network transmission disruption systemic negligence exemptions', 'Critical'),
(904, 504, 'Exclusion 9.2', 'Prior knowledge of retroactive notification billing errors', 'Critical');

-- 5. Populating Placed Recommendation Summary Confirmations
INSERT INTO ComparisonRecommendations (recommendation_id, client_id, selected_policy_id, total_quotes_evaluated, advisory_status, final_broker_signoff_user) VALUES
(3001, 1, 501, 3, 'Bound_Confirmed', 'broker_vaibhav_yadav'),
(3002, 2, 504, 1, 'Presented_To_Client', 'broker_vaibhav_yadav');

-- 6. Populating Compliance Audit Trail History & Overrides
INSERT INTO AdvisoryAuditLogs (log_id, policy_id, operator_username, governance_action, action_execution_timestamp, target_clause_reference, compliance_override_justification) VALUES 
(1001, 501, 'broker_vaibhav_yadav', 'AI_Extraction_Run', '2026-06-25 09:20:00', NULL, NULL),
(1002, 501, 'broker_vaibhav_yadav', 'Manual_Override_Save', '2026-06-26 14:22:00', 'Section 4.2', 'Verified client runs automated CrowdStrike Falcon EDR endpoint protection profiles across all nodes.'),
(1003, 501, 'broker_vaibhav_yadav', 'Advisory_Final_Approve', '2026-06-27 11:00:00', NULL, 'Comprehensive D&O and Cyber risk mapping approved for executive sign-off.');
