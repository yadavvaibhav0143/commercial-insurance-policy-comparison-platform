-- ==============================================================================
-- PORTFOLIO ASSET: COMMERCIAL INSURANCE POLICY COMPARISON & RISK INSIGHTS PLATFORM
-- ==============================================================================

-- Order-dependent destruction sequences to avoid structural constraint violations
DROP TABLE IF EXISTS CorporateClients;
DROP TABLE IF EXISTS InsurancePolicies;
DROP TABLE IF EXISTS PolicyCoverages;
DROP TABLE IF EXISTS PolicyExclusions;
DROP TABLE IF EXISTS PolicyComparisons;
DROP TABLE IF EXISTS Recommendations;
DROP TABLE IF EXISTS AdvisoryAuditLogs;
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
-- 2. TRANSACTIONAL LEDGER: COMMERCIAL INSURANCE POLICIES
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
-- 3. POLICY EXCLUSION DATA: IDENTIFIED POLICY EXCLUSIONS & RISK SEVERITY
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
-- 5. POLICY COMPARISON LAYER: POLICY COMPARISON RECORDS
-- ==============================================================================
CREATE TABLE PolicyComparisons (
    comparison_id INT PRIMARY KEY,
    base_policy_id INT NOT NULL,
    comparison_policy_id INT NOT NULL,
    comparison_date DATE NOT NULL,
    comparison_status VARCHAR(20) NOT NULL CHECK (comparison_status IN ('Completed', 'Pending')),
     broker_user_id INT NOT NULL,
    comparison_started_at TIMESTAMP,
    comparison_completed_at TIMESTAMP,
    CONSTRAINT fk_comparison_base_policy FOREIGN KEY (base_policy_id)   REFERENCES InsurancePolicies(policy_id),
   CONSTRAINT fk_comparison_policy FOREIGN KEY (comparison_policy_id)  REFERENCES InsurancePolicies(policy_id)
);    

-- ==============================================================================
-- 6. DECISION LAYER: BROKER COMPARISON & PLACEMENT PLACEMENTS
-- ==============================================================================
CREATE TABLE Recommendations (
    recommendation_id INT NOT NULL,
    comparison_id INT NOT NULL,
    recommendation_version INT NOT NULL,
    recommendation_type VARCHAR(30) NOT NULL CHECK (recommendation_type IN ('Best Match', 'Gap Identified')),
    recommendation_status VARCHAR(20) NOT NULL CHECK (recommendation_status IN ('Draft', 'Approved')),
    recommendation_started_at TIMESTAMP, recommendation_completed_at TIMESTAMP,
    PRIMARY KEY (recommendation_id, recommendation_version),
    CONSTRAINT fk_recommendation_comparison   FOREIGN KEY (comparison_id)  REFERENCES PolicyComparisons(comparison_id)
);

-- ==============================================================================
-- 7. GOVERNANCE LAYER: IMMUTABLE COMPLIANCE OVERRIDE AUDIT LOGS
-- ==============================================================================
CREATE TABLE AdvisoryAuditLogs (
    audit_id INT PRIMARY KEY,
    entity_type VARCHAR(30) NOT NULL,
    entity_id INT NOT NULL,
    action VARCHAR(30) NOT NULL,
    performed_by VARCHAR(50) NOT NULL,
    action_timestamp TIMESTAMP NOT NULL
);


