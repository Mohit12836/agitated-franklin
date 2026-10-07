-- =========================================================================
-- MOHIT JAIN AI WEBSITE SALES & DISCOVERY ENGINE: SUPABASE POSTGRESQL SCHEMA
-- =========================================================================
-- Source of truth for all leads, AI dynamic diagnostics, opportunity reports,
-- quotations, payments, VIP onboarding data, and maintenance retainers.

-- 1. Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. ORGANIZATIONS (Your Agency / Multi-Tenant Agency Support)
CREATE TABLE IF NOT EXISTS organizations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL DEFAULT 'Mohit Jain Digital',
    owner_email VARCHAR(255) NOT NULL,
    whatsapp_number VARCHAR(50),
    google_sheet_webhook_url TEXT,
    google_drive_folder_id TEXT,
    currency VARCHAR(10) DEFAULT 'INR',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. LEADS (Contacts from Meta/WhatsApp Ads)
CREATE TABLE IF NOT EXISTS leads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    org_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
    name VARCHAR(255),
    phone VARCHAR(50) NOT NULL,
    email VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100) DEFAULT 'India',
    business_name VARCHAR(255),
    industry VARCHAR(100), -- 'Industrial B2B', 'Retail', 'E-commerce', 'Healthcare', 'Consulting', etc.
    customer_type VARCHAR(50), -- 'B2B', 'B2C', 'Both'
    lifecycle_stage VARCHAR(50) DEFAULT 'New Lead', -- 'New Lead', 'In Discovery', 'Opportunity Generated', 'Proposal Sent', 'Token Paid', 'Onboarded', 'In Production', 'Live & Retained', 'Lost'
    lead_score INTEGER DEFAULT 0, -- 0 to 100
    potential_deal_value NUMERIC(12, 2) DEFAULT 0.00,
    potential_mrr NUMERIC(12, 2) DEFAULT 0.00,
    source VARCHAR(100) DEFAULT 'WhatsApp Ad',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. DISCOVERY SESSIONS (Interactive Dynamic Diagnostic Sessions)
CREATE TABLE IF NOT EXISTS discovery_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
    session_token VARCHAR(100) UNIQUE NOT NULL,
    total_questions_answered INTEGER DEFAULT 0,
    is_completed BOOLEAN DEFAULT FALSE,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    completed_at TIMESTAMP WITH TIME ZONE
);

-- 5. QUESTION ANSWERS (Every Single Dynamic Response Recorded)
CREATE TABLE IF NOT EXISTS question_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID REFERENCES discovery_sessions(id) ON DELETE CASCADE,
    question_key VARCHAR(100) NOT NULL,
    question_text TEXT NOT NULL,
    selected_option_key VARCHAR(100),
    answer_text TEXT NOT NULL,
    signal_extracted JSONB DEFAULT '{}'::jsonb, -- e.g. {"budget_signal": "high", "pain": "manual_whatsapp"}
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. LEAD INTELLIGENCE PROFILES (Extracted Psychological Signals)
CREATE TABLE IF NOT EXISTS lead_intelligence_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lead_id UUID REFERENCES leads(id) ON DELETE CASCADE UNIQUE,
    business_scale VARCHAR(50), -- 'Micro', 'Growing Local', 'Established Regional', 'National / Export'
    current_acquisition_channels JSONB DEFAULT '[]'::jsonb, -- ['WhatsApp', 'Referral', 'Instagram']
    primary_pain_points JSONB DEFAULT '[]'::jsonb,
    ambition_level VARCHAR(50), -- 'Basic Presence', 'Market Dominance', 'Pan-India Automation'
    digital_gap_score INTEGER DEFAULT 0, -- 0 to 100 (gap between current state & competitor potential)
    budget_psychology VARCHAR(50), -- 'Budget Conscious (Under 5k)', 'ROI Conscious (10k-30k)', 'High-Ticket Investor (50k-5L)'
    maintenance_preference VARCHAR(50), -- 'One-Time / Zero Mandate', 'Monthly Peace-Of-Mind', 'Full Growth Retainer'
    ai_summary_notes TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 7. OPPORTUNITY REPORTS (AI Generated "Where You Are -> Where You Can Go")
CREATE TABLE IF NOT EXISTS opportunity_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
    report_title VARCHAR(255) NOT NULL,
    current_state_analysis TEXT,
    competitor_landscape_gap TEXT,
    growth_opportunities JSONB DEFAULT '[]'::jsonb, -- [{ "title": "Digital Credibility", "impact": "High" }, ...]
    recommended_ladder_level VARCHAR(50), -- 'Level 1: Presence', 'Level 2: Professional', 'Level 3: Lead Gen Engine', 'Level 4: Growth Automation', 'Level 5: Enterprise'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 8. QUOTATIONS & PROPOSALS (Dynamic Tailored Scope & Pricing)
CREATE TABLE IF NOT EXISTS quotations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
    opportunity_id UUID REFERENCES opportunity_reports(id),
    quote_number VARCHAR(50) UNIQUE NOT NULL,
    plan_name VARCHAR(150) NOT NULL,
    base_price NUMERIC(12, 2) NOT NULL,
    discounted_price NUMERIC(12, 2) NOT NULL,
    recommended_maintenance_price NUMERIC(12, 2) DEFAULT 0.00,
    estimated_delivery_days INTEGER DEFAULT 5,
    scope_deliverables JSONB DEFAULT '[]'::jsonb, -- ["5-7 Custom Pages", "Google Sheets Sync", "SEO Ready", ...]
    status VARCHAR(50) DEFAULT 'Draft', -- 'Draft', 'Sent', 'Viewed', 'Accepted', 'Token Paid', 'Expired'
    valid_until TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 9. PAYMENTS (Advance Token & Milestone Payments)
CREATE TABLE IF NOT EXISTS payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    quotation_id UUID REFERENCES quotations(id),
    lead_id UUID REFERENCES leads(id),
    payment_type VARCHAR(50) DEFAULT 'Advance Token', -- 'Advance Token', 'Full Upfront', 'Milestone 2', 'Final Delivery', 'Monthly Retainer'
    amount NUMERIC(12, 2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'INR',
    gateway VARCHAR(50) DEFAULT 'Razorpay', -- 'Razorpay', 'UPI Direct', 'Bank Transfer', 'Stripe'
    transaction_id VARCHAR(255),
    payment_status VARCHAR(50) DEFAULT 'Pending', -- 'Pending', 'Captured', 'Failed', 'Refunded'
    paid_at TIMESTAMP WITH TIME ZONE
);

-- 10. ONBOARDING PROJECTS (Deep Data Collection AFTER Payment)
CREATE TABLE IF NOT EXISTS onboarding_projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
    quotation_id UUID REFERENCES quotations(id),
    project_code VARCHAR(50) UNIQUE NOT NULL,
    registered_business_name VARCHAR(255),
    gst_number VARCHAR(50),
    domain_status VARCHAR(50), -- 'Needs New Domain', 'Already Owned', 'Subdomain'
    domain_name VARCHAR(255),
    google_drive_folder_url TEXT,
    logo_file_url TEXT,
    brand_color_preferences VARCHAR(100),
    core_services_products TEXT,
    target_audiences TEXT,
    competitor_reference_links JSONB DEFAULT '[]'::jsonb,
    content_readiness VARCHAR(50), -- 'Ready with client', 'Need AI Copywriting', 'Need Fresh Photoshoot'
    submission_status VARCHAR(50) DEFAULT 'Draft', -- 'Draft', 'Submitted', 'Under Production', 'QA Passed', 'Live'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 11. MAINTENANCE SUBSCRIPTIONS (Post-Launch Client Retainers)
CREATE TABLE IF NOT EXISTS maintenance_subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
    project_id UUID REFERENCES onboarding_projects(id),
    plan_name VARCHAR(100) NOT NULL,
    monthly_fee NUMERIC(12, 2) NOT NULL,
    billing_cycle VARCHAR(20) DEFAULT 'Monthly', -- 'Monthly', 'Quarterly', 'Yearly'
    status VARCHAR(50) DEFAULT 'Active', -- 'Active', 'Paused', 'Cancelled'
    next_billing_date DATE,
    tasks_allocated_per_month INTEGER DEFAULT 5,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- INDEXES FOR ULTRA-FAST LOOKUPS & CRM DASHBOARDS
CREATE INDEX IF NOT EXISTS idx_leads_phone ON leads(phone);
CREATE INDEX IF NOT EXISTS idx_leads_stage ON leads(lifecycle_stage);
CREATE INDEX IF NOT EXISTS idx_leads_score ON leads(lead_score);
CREATE INDEX IF NOT EXISTS idx_quotations_lead ON quotations(lead_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(payment_status);
CREATE INDEX IF NOT EXISTS idx_onboarding_lead ON onboarding_projects(lead_id);
