-- ==============================================================================
-- PORTFOLIO ASSET: COMMERCIAL INSURANCE PLACEMENT ENGINE
-- DESIGN LAYER: RELATIONAL DATA ARCHITECTURE (DDL SCHEMA)
-- SENIOR TECHNICAL BA / FUNCTIONAL CONSULTANT TIER
-- ==============================================================================

-- Order-dependent destruction sequences to avoid structural constraint violations
DROP TABLE IF EXISTS AdvisoryAuditLogs;
DROP TABLE IF EXISTS ComparisonRecommendations;
DROP TABLE IF EXISTS PolicyExclusions;
DROP TABLE IF EXISTS PolicyCoverages;
DROP TABLE IF EXISTS InsurancePolicies;
DROP TABLE IF EXISTS CorporateClients;

-- ==============================================================================
-- 1. MASTER LEDGER: CORPORATE CLIENT RISK PROFILES
-- ==============================================================================
CREATE TABLE CorporateClients (
    client_id INT PRIMARY KEY,
    legal_entity_name VARCHAR(100) NOT NULL,
    industry_sector VARCHAR(50) NOT NULL,
    account_revenue_tier VARCHAR(20) NOT NULL CHECK (account_revenue_tier IN ('Enterprise', 'Mid-Market', 'SMB')),
    risk_appetite_rating VARCHAR(20) NOT NULL CHECK (risk_appetite_rating IN ('Risk-Averse', 'Balanced', 'Aggressive'))
);

-- ==============================================================================
-- 2. TRANSACTIONAL LEDGER: UNDERWRITER CARRIER QUOTATIONS
-- ==============================================================================
CREATE TABLE InsurancePolicies (
    policy_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    underwriter_carrier VARCHAR(50) NOT NULL,
    policy_type VARCHAR(50) NOT NULL CHECK (policy_type IN ('Cyber Liability', 'Directors & Officers', 'Errors & Omissions')),
    annual_premium_amount DECIMAL(15,2) NOT NULL CHECK (annual_premium_amount > 0),
    document_upload_timestamp TIMESTAMP NOT NULL,
    ai_extraction_status VARCHAR(20) NOT NULL CHECK (ai_extraction_status IN ('Completed', 'Failed', 'Pending')),
    CONSTRAINT fk_policy_client FOREIGN KEY (client_id) REFERENCES CorporateClients(client_id) ON DELETE CASCADE
);

-- ==============================================================================
-- 3. SUB-TRANSACTIONAL LEDGER: EXTRACTED CLAUSE COVERAGE BOUNDARIES
-- ==============================================================================
CREATE TABLE PolicyCoverages (
    coverage_id INT PRIMARY KEY,
    policy_id INT NOT NULL,
    contract_clause_reference VARCHAR(30) NOT NULL,
    coverage_term_raw VARCHAR(100) NOT NULL,
    normalized_taxonomy_group VARCHAR(50) NOT NULL,
    aggregate_coverage_limit DECIMAL(15,2) NOT NULL,
    inner_sub_limit_cap DECIMAL(15,2) DEFAULT 0.00,
    CONSTRAINT fk_coverage_parent_policy FOREIGN KEY (policy_id) REFERENCES InsurancePolicies(policy_id) ON DELETE CASCADE
);

-- ==============================================================================
-- 4. SUB-TRANSACTIONAL LEDGER: CRITICAL RISK EXCLUSIONS
-- ==============================================================================
CREATE TABLE PolicyExclusions (
    exclusion_id INT PRIMARY KEY,
    policy_id INT NOT NULL,
    contract_clause_reference VARCHAR(30) NOT NULL,
    exclusion_title_raw VARCHAR(150) NOT NULL,
    unmitigated_risk_severity VARCHAR(20) NOT NULL CHECK (unmitigated_risk_severity IN ('Critical', 'Standard', 'Low')),
    CONSTRAINT fk_exclusion_parent_policy FOREIGN KEY (policy_id) REFERENCES InsurancePolicies(policy_id) ON DELETE CASCADE
);

-- ==============================================================================
-- 5. DECISION LAYER: BROKER COMPARISON & PLACEMENT PLACEMENTS
-- ==============================================================================
CREATE TABLE ComparisonRecommendations (
    recommendation_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    selected_policy_id INT NOT NULL,
    total_quotes_evaluated INT NOT NULL CHECK (total_quotes_evaluated > 0),
    advisory_status VARCHAR(20) NOT NULL CHECK (advisory_status IN ('Draft', 'Presented_To_Client', 'Bound_Confirmed')),
    final_broker_signoff_user VARCHAR(50) NOT NULL,
    CONSTRAINT fk_recommendation_client FOREIGN KEY (client_id) REFERENCES CorporateClients(client_id) ON DELETE CASCADE,
    CONSTRAINT fk_recommendation_policy FOREIGN KEY (selected_policy_id) REFERENCES InsurancePolicies(policy_id)
);

-- ==============================================================================
-- 6. GOVERNANCE LAYER: IMMUTABLE COMPLIANCE OVERRIDE AUDIT LOGS
-- ==============================================================================
CREATE TABLE AdvisoryAuditLogs (
    log_id INT PRIMARY KEY,
    policy_id INT NOT NULL,
    operator_username VARCHAR(50) NOT NULL,
    governance_action VARCHAR(30) NOT NULL CHECK (governance_action IN ('AI_Extraction_Run', 'Manual_Override_Save', 'Advisory_Final_Approve')),
    action_execution_timestamp TIMESTAMP NOT NULL,
    target_clause_reference VARCHAR(30) NULL,
    compliance_override_justification TEXT NULL,
    CONSTRAINT fk_audit_parent_policy FOREIGN KEY (policy_id) REFERENCES InsurancePolicies(policy_id) ON DELETE CASCADE
);
