-- ============================================================================
-- INSURANCE MARKETING & MEDIA ANALYTICS DATA MODEL
-- Comprehensive synthetic dataset for advanced marketing analytics
-- Supports: micro-segmentation, cross-sell/upsell, churn prediction, attribution
-- ============================================================================
CREATE DATABASE INS_CO;
-- Schema setup
CREATE SCHEMA IF NOT EXISTS MARKETING_ANALYTICS;
USE SCHEMA MARKETING_ANALYTICS;

-- ============================================================================
-- CUSTOMER & DEMOGRAPHIC DATA
-- ============================================================================

CREATE OR REPLACE TABLE customers (
    customer_id STRING PRIMARY KEY,
    customer_type STRING, -- 'prospect', 'active', 'lapsed'
    acquisition_date DATE,
    first_name STRING,
    last_name STRING,
    email STRING,
    phone STRING,
    date_of_birth DATE,
    gender STRING,
    marital_status STRING,
    household_income NUMBER(10,2),
    education_level STRING,
    employment_status STRING,
    occupation STRING,
    address_line1 STRING,
    city STRING,
    state STRING,
    zip_code STRING,
    credit_score NUMBER(3,0),
    risk_profile STRING, -- 'low', 'medium', 'high'
    lifetime_value NUMBER(10,2),
    churn_risk_score DECIMAL(3,2), -- 0.00 to 1.00
    last_policy_interaction_date DATE,
    total_policies_owned NUMBER(2,0),
    preferred_contact_method STRING,
    digital_engagement_score DECIMAL(3,2),
    agent_id STRING,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- INSURANCE PRODUCTS & POLICIES
-- ============================================================================

CREATE OR REPLACE TABLE insurance_products (
    product_id STRING PRIMARY KEY,
    product_name STRING,
    product_category STRING, -- 'auto', 'home', 'life', 'health', 'commercial'
    product_subcategory STRING,
    base_premium NUMBER(8,2),
    commission_rate DECIMAL(4,3),
    target_age_min NUMBER(3,0),
    target_age_max NUMBER(3,0),
    target_income_min NUMBER(10,2),
    target_income_max NUMBER(10,2),
    risk_factors STRING, -- JSON array
    cross_sell_affinity DECIMAL(3,2), -- likelihood to buy with other products
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE customer_policies (
    policy_id STRING PRIMARY KEY,
    customer_id STRING,
    product_id STRING,
    policy_status STRING, -- 'active', 'lapsed', 'cancelled'
    start_date DATE,
    end_date DATE,
    premium_amount NUMBER(8,2),
    coverage_amount NUMBER(12,2),
    deductible NUMBER(6,2),
    payment_frequency STRING, -- 'monthly', 'quarterly', 'annually'
    auto_renewal_flag BOOLEAN,
    claims_count NUMBER(3,0),
    last_payment_date DATE,
    next_renewal_date DATE,
    acquisition_channel STRING,
    acquisition_campaign_id STRING,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES insurance_products(product_id)
);

-- ============================================================================
-- MARKETING CAMPAIGNS & PLANNING
-- ============================================================================

CREATE OR REPLACE TABLE marketing_campaigns (
    campaign_id STRING PRIMARY KEY,
    campaign_name STRING,
    campaign_type STRING, -- 'acquisition', 'retention', 'cross_sell', 'upsell'
    campaign_objective STRING,
    target_product_ids ARRAY,
    target_segments ARRAY,
    channel_mix STRING, -- 'digital', 'traditional', 'agent', 'mixed'
    start_date DATE,
    end_date DATE,
    total_budget NUMBER(10,2),
    planned_impressions NUMBER(12,0),
    planned_clicks NUMBER(10,0),
    planned_conversions NUMBER(8,0),
    planned_revenue NUMBER(12,2),
    campaign_status STRING, -- 'planning', 'active', 'completed', 'cancelled'
    created_by STRING,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE campaign_forecasts (
    forecast_id STRING PRIMARY KEY,
    campaign_id STRING,
    forecast_date DATE,
    forecast_period STRING, -- 'monthly', 'quarterly', 'annual'
    forecasted_spend NUMBER(10,2),
    forecasted_impressions NUMBER(12,0),
    forecasted_clicks NUMBER(10,0),
    forecasted_leads NUMBER(8,0),
    forecasted_conversions NUMBER(6,0),
    forecasted_revenue NUMBER(12,2),
    forecast_confidence DECIMAL(3,2),
    forecast_model STRING, -- 'historical', 'regression', 'ml_model'
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(campaign_id)
);

-- ============================================================================
-- ADVERTISING & MEDIA DATA
-- ============================================================================

CREATE OR REPLACE TABLE advertising_channels (
    channel_id STRING PRIMARY KEY,
    channel_name STRING, -- 'google_ads', 'facebook', 'tv', 'radio', 'direct_mail'
    channel_type STRING, -- 'digital', 'traditional', 'direct'
    cost_model STRING, -- 'cpc', 'cpm', 'cpa', 'fixed'
    attribution_window NUMBER(3,0), -- days
    default_attribution_weight DECIMAL(3,2)
);

CREATE OR REPLACE TABLE ad_campaigns (
    ad_campaign_id STRING PRIMARY KEY,
    campaign_id STRING,
    channel_id STRING,
    ad_set_name STRING,
    targeting_criteria STRING, -- JSON object
    budget_type STRING, -- 'daily', 'lifetime'
    budget_amount NUMBER(8,2),
    bid_strategy STRING,
    start_date DATE,
    end_date DATE,
    campaign_status STRING,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(campaign_id),
    FOREIGN KEY (channel_id) REFERENCES advertising_channels(channel_id)
);

CREATE OR REPLACE TABLE daily_ad_performance (
    performance_id STRING PRIMARY KEY,
    ad_campaign_id STRING,
    date DATE,
    impressions NUMBER(10,0),
    clicks NUMBER(8,0),
    conversions NUMBER(6,0),
    spend NUMBER(8,2),
    cost_per_click DECIMAL(6,2),
    cost_per_conversion DECIMAL(8,2),
    click_through_rate DECIMAL(5,4),
    conversion_rate DECIMAL(5,4),
    reach NUMBER(10,0),
    frequency DECIMAL(4,2),
    video_views NUMBER(8,0),
    video_completion_rate DECIMAL(4,3),
    engagement_rate DECIMAL(5,4),
    quality_score DECIMAL(3,1),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (ad_campaign_id) REFERENCES ad_campaigns(ad_campaign_id)
);

-- ============================================================================
-- CRM & LEAD MANAGEMENT
-- ============================================================================

CREATE OR REPLACE TABLE leads (
    lead_id STRING PRIMARY KEY,
    customer_id STRING,
    lead_source STRING,
    lead_medium STRING,
    campaign_id STRING,
    ad_campaign_id STRING,
    lead_status STRING, -- 'new', 'contacted', 'qualified', 'nurturing', 'converted', 'lost'
    lead_score NUMBER(3,0),
    product_interest ARRAY,
    contact_preference STRING,
    urgency_level STRING, -- 'low', 'medium', 'high'
    lead_value_estimate NUMBER(8,2),
    first_contact_date DATE,
    last_contact_date DATE,
    conversion_date DATE,
    days_to_conversion NUMBER(4,0),
    assigned_agent_id STRING,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(campaign_id)
);

CREATE OR REPLACE TABLE lead_activities (
    activity_id STRING PRIMARY KEY,
    lead_id STRING,
    activity_type STRING, -- 'email_open', 'email_click', 'call', 'meeting', 'quote_request'
    activity_date TIMESTAMP_NTZ,
    channel STRING,
    agent_id STRING,
    activity_outcome STRING,
    notes STRING,
    next_action STRING,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (lead_id) REFERENCES leads(lead_id)
);

-- ============================================================================
-- WEB ANALYTICS & DIGITAL ENGAGEMENT
-- ============================================================================

CREATE OR REPLACE TABLE website_sessions (
    session_id STRING PRIMARY KEY,
    customer_id STRING,
    visitor_id STRING,
    session_start TIMESTAMP_NTZ,
    session_end TIMESTAMP_NTZ,
    page_views NUMBER(3,0),
    time_on_site NUMBER(6,0), -- seconds
    bounce_rate BOOLEAN,
    traffic_source STRING,
    traffic_medium STRING,
    campaign STRING,
    device_type STRING,
    browser STRING,
    operating_system STRING,
    location_country STRING,
    location_state STRING,
    location_city STRING,
    is_new_visitor BOOLEAN,
    conversion_flag BOOLEAN,
    goal_completions NUMBER(2,0),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE OR REPLACE TABLE website_events (
    event_id STRING PRIMARY KEY,
    session_id STRING,
    customer_id STRING,
    event_timestamp TIMESTAMP_NTZ,
    event_category STRING,
    event_action STRING,
    event_label STRING,
    page_url STRING,
    page_title STRING,
    custom_dimensions OBJECT,
    event_value NUMBER(8,2),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (session_id) REFERENCES website_sessions(session_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE OR REPLACE TABLE email_campaigns (
    email_campaign_id STRING PRIMARY KEY,
    campaign_id STRING,
    email_subject STRING,
    email_type STRING, -- 'newsletter', 'promotional', 'nurture', 'retention'
    send_date DATE,
    total_sent NUMBER(8,0),
    total_delivered NUMBER(8,0),
    total_opens NUMBER(8,0),
    total_clicks NUMBER(6,0),
    total_conversions NUMBER(4,0),
    unsubscribes NUMBER(4,0),
    spam_complaints NUMBER(3,0),
    open_rate DECIMAL(5,4),
    click_rate DECIMAL(5,4),
    conversion_rate DECIMAL(5,4),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(campaign_id)
);

-- ============================================================================
-- ATTRIBUTION & CUSTOMER JOURNEY
-- ============================================================================

CREATE OR REPLACE TABLE customer_touchpoints (
    touchpoint_id STRING PRIMARY KEY,
    customer_id STRING,
    session_id STRING,
    touchpoint_timestamp TIMESTAMP_NTZ,
    channel STRING,
    campaign_id STRING,
    ad_campaign_id STRING,
    touchpoint_type STRING, -- 'awareness', 'consideration', 'purchase', 'retention'
    interaction_value DECIMAL(4,3),
    content_consumed STRING,
    engagement_score DECIMAL(3,2),
    position_in_journey NUMBER(3,0),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (session_id) REFERENCES website_sessions(session_id),
    FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(campaign_id)
);

CREATE OR REPLACE TABLE attribution_models (
    model_id STRING PRIMARY KEY,
    model_name STRING,
    model_type STRING, -- 'first_touch', 'last_touch', 'linear', 'time_decay', 'position_based'
    attribution_logic STRING,
    lookback_window NUMBER(3,0), -- days
    channel_weights OBJECT,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE attribution_results (
    attribution_id STRING PRIMARY KEY,
    customer_id STRING,
    policy_id STRING,
    model_id STRING,
    touchpoint_id STRING,
    channel STRING,
    campaign_id STRING,
    attribution_credit DECIMAL(5,4),
    attributed_revenue NUMBER(8,2),
    conversion_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (policy_id) REFERENCES customer_policies(policy_id),
    FOREIGN KEY (model_id) REFERENCES attribution_models(model_id),
    FOREIGN KEY (touchpoint_id) REFERENCES customer_touchpoints(touchpoint_id)
);

-- ============================================================================
-- CREATIVE & CONTENT METADATA
-- ============================================================================

CREATE OR REPLACE TABLE creative_assets (
    creative_id STRING PRIMARY KEY,
    creative_name STRING,
    creative_type STRING, -- 'display_banner', 'video', 'social_image', 'email_template'
    format STRING,
    dimensions STRING,
    file_size_kb NUMBER(8,0),
    duration_seconds NUMBER(4,0), -- for video/audio
    theme STRING,
    message_strategy STRING,
    call_to_action STRING,
    target_audience STRING,
    brand_guidelines_compliant BOOLEAN,
    performance_score DECIMAL(3,2),
    created_date DATE,
    created_by STRING,
    approved_date DATE,
    approved_by STRING,
    tags ARRAY,
    creative_url STRING,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE ad_creative_performance (
    performance_id STRING PRIMARY KEY,
    ad_campaign_id STRING,
    creative_id STRING,
    date DATE,
    impressions NUMBER(8,0),
    clicks NUMBER(6,0),
    conversions NUMBER(4,0),
    spend NUMBER(6,2),
    engagement_rate DECIMAL(5,4),
    creative_effectiveness_score DECIMAL(3,2),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (ad_campaign_id) REFERENCES ad_campaigns(ad_campaign_id),
    FOREIGN KEY (creative_id) REFERENCES creative_assets(creative_id)
);

-- ============================================================================
-- CUSTOMER SEGMENTATION & ANALYTICS
-- ============================================================================

CREATE OR REPLACE TABLE customer_segments (
    segment_id STRING PRIMARY KEY,
    segment_name STRING,
    segment_description STRING,
    segment_criteria STRING, -- JSON object with rules
    segment_size NUMBER(8,0),
    avg_ltv NUMBER(8,2),
    avg_churn_risk DECIMAL(3,2),
    priority_score NUMBER(2,0),
    created_date DATE,
    last_updated DATE,
    created_by STRING,
    status STRING -- 'active', 'archived'
);

CREATE OR REPLACE TABLE customer_segment_membership (
    membership_id STRING PRIMARY KEY,
    customer_id STRING,
    segment_id STRING,
    entry_date DATE,
    exit_date DATE,
    confidence_score DECIMAL(3,2),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (segment_id) REFERENCES customer_segments(segment_id)
);

CREATE OR REPLACE TABLE predictive_models (
    model_id STRING PRIMARY KEY,
    model_name STRING,
    model_type STRING, -- 'churn_prediction', 'cross_sell', 'upsell', 'ltv_prediction'
    model_algorithm STRING,
    training_data_period STRING,
    feature_importance OBJECT,
    model_accuracy DECIMAL(5,4),
    last_trained_date DATE,
    model_version STRING,
    deployment_status STRING,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE model_predictions (
    prediction_id STRING PRIMARY KEY,
    customer_id STRING,
    model_id STRING,
    prediction_date DATE,
    prediction_value DECIMAL(5,4),
    confidence_interval STRING,
    model_features OBJECT,
    action_recommended STRING,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (model_id) REFERENCES predictive_models(model_id)
);

-- ============================================================================
-- FINANCIAL PLANNING & ACTUALS
-- ============================================================================

CREATE OR REPLACE TABLE budget_planning (
    budget_id STRING PRIMARY KEY,
    budget_year NUMBER(4,0),
    budget_quarter NUMBER(1,0),
    budget_month NUMBER(2,0),
    channel_id STRING,
    product_category STRING,
    campaign_type STRING,
    planned_spend NUMBER(10,2),
    planned_impressions NUMBER(12,0),
    planned_leads NUMBER(8,0),
    planned_conversions NUMBER(6,0),
    planned_revenue NUMBER(12,2),
    cost_per_lead_target DECIMAL(6,2),
    cost_per_acquisition_target DECIMAL(8,2),
    roas_target DECIMAL(4,2), -- Return on Ad Spend
    roi_target DECIMAL(4,2), -- Return on Investment
    created_date DATE,
    created_by STRING,
    approved_date DATE,
    approved_by STRING,
    FOREIGN KEY (channel_id) REFERENCES advertising_channels(channel_id)
);

CREATE OR REPLACE TABLE actual_performance (
    actual_id STRING PRIMARY KEY,
    budget_id STRING,
    performance_date DATE,
    actual_spend NUMBER(10,2),
    actual_impressions NUMBER(12,0),
    actual_leads NUMBER(8,0),
    actual_conversions NUMBER(6,0),
    actual_revenue NUMBER(12,2),
    variance_spend_pct DECIMAL(5,2),
    variance_leads_pct DECIMAL(5,2),
    variance_revenue_pct DECIMAL(5,2),
    cost_per_lead DECIMAL(6,2),
    cost_per_acquisition DECIMAL(8,2),
    roas_actual DECIMAL(4,2),
    roi_actual DECIMAL(4,2),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (budget_id) REFERENCES budget_planning(budget_id)
);

-- ============================================================================
-- EVENT & CAMPAIGN METADATA
-- ============================================================================

CREATE OR REPLACE TABLE marketing_events (
    event_id STRING PRIMARY KEY,
    event_name STRING,
    event_type STRING, -- 'webinar', 'trade_show', 'sponsorship', 'community_event'
    event_date DATE,
    event_location STRING,
    target_audience STRING,
    expected_attendance NUMBER(6,0),
    actual_attendance NUMBER(6,0),
    event_cost NUMBER(8,2),
    leads_generated NUMBER(4,0),
    conversions NUMBER(3,0),
    roi DECIMAL(4,2),
    event_satisfaction_score DECIMAL(3,2),
    follow_up_campaign_id STRING,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- SNOWFLAKE PERFORMANCE OPTIMIZATION
-- ============================================================================

-- Snowflake doesn't use traditional indexes. Instead, use these optimization techniques:

-- 1. CLUSTER KEYS for frequently filtered columns (uncomment as needed)
-- ALTER TABLE customers CLUSTER BY (customer_type, churn_risk_score);
-- ALTER TABLE daily_ad_performance CLUSTER BY (date);
-- ALTER TABLE customer_touchpoints CLUSTER BY (customer_id, touchpoint_timestamp);
-- ALTER TABLE website_sessions CLUSTER BY (customer_id, session_start);

-- 2. SEARCH OPTIMIZATION SERVICE for point lookups and text searches (uncomment as needed)
-- ALTER TABLE customers ADD SEARCH OPTIMIZATION;
-- ALTER TABLE leads ADD SEARCH OPTIMIZATION;
-- ALTER TABLE website_sessions ADD SEARCH OPTIMIZATION;

-- 3. AUTOMATIC CLUSTERING can be enabled for large tables:
-- ALTER TABLE daily_ad_performance SUSPEND RECLUSTER;
-- ALTER TABLE daily_ad_performance RESUME RECLUSTER;

-- Note: Snowflake automatically optimizes queries using micro-partitions and metadata.
-- These optimizations should only be applied based on actual query patterns and data volume.

-- ============================================================================
-- VIEWS FOR COMMON ANALYTICS
-- ============================================================================

-- Customer 360 view
CREATE OR REPLACE VIEW customer_360 AS
SELECT 
    c.*,
    COUNT(DISTINCT p.policy_id) as total_policies,
    SUM(p.premium_amount) as total_premium,
    AVG(mp.prediction_value) as avg_churn_probability,
    MAX(ws.session_start) as last_website_visit,
    COUNT(DISTINCT l.lead_id) as total_leads,
    LISTAGG(DISTINCT cs.segment_name, ', ') as segments
FROM customers c
LEFT JOIN customer_policies p ON c.customer_id = p.customer_id AND p.policy_status = 'active'
LEFT JOIN model_predictions mp ON c.customer_id = mp.customer_id AND mp.model_id LIKE '%churn%'
LEFT JOIN website_sessions ws ON c.customer_id = ws.customer_id
LEFT JOIN leads l ON c.customer_id = l.customer_id
LEFT JOIN customer_segment_membership csm ON c.customer_id = csm.customer_id AND csm.exit_date IS NULL
LEFT JOIN customer_segments cs ON csm.segment_id = cs.segment_id
GROUP BY c.customer_id, c.customer_type, c.acquisition_date, c.first_name, c.last_name, 
         c.email, c.phone, c.date_of_birth, c.gender, c.marital_status, c.household_income,
         c.education_level, c.employment_status, c.occupation, c.address_line1, c.city,
         c.state, c.zip_code, c.credit_score, c.risk_profile, c.lifetime_value,
         c.churn_risk_score, c.last_policy_interaction_date, c.total_policies_owned,
         c.preferred_contact_method, c.digital_engagement_score, c.agent_id,
         c.created_at, c.updated_at;

-- Campaign performance summary
CREATE OR REPLACE VIEW campaign_performance_summary AS
SELECT 
    mc.campaign_id,
    mc.campaign_name,
    mc.campaign_type,
    mc.total_budget,
    SUM(dap.spend) as actual_spend,
    SUM(dap.impressions) as total_impressions,
    SUM(dap.clicks) as total_clicks,
    SUM(dap.conversions) as total_conversions,
    COUNT(DISTINCT l.lead_id) as total_leads,
    SUM(ap.actual_revenue) as total_revenue,
    DIV0(SUM(dap.spend), SUM(dap.conversions)) as cost_per_conversion,
    DIV0(SUM(ap.actual_revenue), SUM(dap.spend)) as roas
FROM marketing_campaigns mc
LEFT JOIN ad_campaigns ac ON mc.campaign_id = ac.campaign_id
LEFT JOIN daily_ad_performance dap ON ac.ad_campaign_id = dap.ad_campaign_id
LEFT JOIN leads l ON mc.campaign_id = l.campaign_id
LEFT JOIN budget_planning bp ON mc.campaign_id = bp.budget_id
LEFT JOIN actual_performance ap ON bp.budget_id = ap.budget_id
GROUP BY mc.campaign_id, mc.campaign_name, mc.campaign_type, mc.total_budget;




-- ============================================================================
-- SAMPLE DATA GENERATION FOR INSURANCE MARKETING ANALYTICS
-- Demonstrates cross-sell, upsell, churn prediction, and segmentation
-- ============================================================================

-- Use the marketing analytics schema
USE SCHEMA MARKETING_ANALYTICS;

-- ============================================================================
-- REFERENCE DATA - Supporting tables
-- ============================================================================

-- Insurance Products
INSERT INTO insurance_products VALUES
('AUTO_BASIC', 'Basic Auto Insurance', 'auto', 'liability', 800.00, 0.12, 18, 75, 25000, 150000, '["driving_record", "vehicle_age"]', 0.65, CURRENT_TIMESTAMP()),
('AUTO_FULL', 'Full Coverage Auto', 'auto', 'comprehensive', 1200.00, 0.15, 18, 75, 35000, 250000, '["driving_record", "vehicle_value"]', 0.45, CURRENT_TIMESTAMP()),
('HOME_BASIC', 'Basic Homeowners', 'home', 'dwelling', 900.00, 0.18, 25, 80, 40000, 300000, '["property_age", "location"]', 0.70, CURRENT_TIMESTAMP()),
('HOME_PREMIUM', 'Premium Homeowners', 'home', 'comprehensive', 1500.00, 0.20, 25, 80, 60000, 500000, '["property_value", "location"]', 0.40, CURRENT_TIMESTAMP()),
('LIFE_TERM', 'Term Life Insurance', 'life', 'term', 300.00, 0.25, 18, 70, 20000, 200000, '["health", "age", "lifestyle"]', 0.60, CURRENT_TIMESTAMP()),
('LIFE_WHOLE', 'Whole Life Insurance', 'life', 'permanent', 800.00, 0.30, 18, 70, 40000, 400000, '["health", "age", "income"]', 0.35, CURRENT_TIMESTAMP()),
('HEALTH_BASIC', 'Basic Health Plan', 'health', 'individual', 400.00, 0.08, 18, 65, 20000, 100000, '["health_history", "age"]', 0.50, CURRENT_TIMESTAMP()),
('HEALTH_PREMIUM', 'Premium Health Plan', 'health', 'family', 1200.00, 0.10, 18, 65, 50000, 200000, '["health_history", "family_size"]', 0.30, CURRENT_TIMESTAMP());

-- Advertising Channels
INSERT INTO advertising_channels VALUES
('GOOGLE_ADS', 'Google Ads', 'digital', 'cpc', 30, 0.40),
('FACEBOOK', 'Facebook Ads', 'digital', 'cpm', 30, 0.25),
('TV_LOCAL', 'Local TV', 'traditional', 'cpm', 7, 0.15),
('RADIO', 'Radio Advertising', 'traditional', 'cpm', 7, 0.10),
('DIRECT_MAIL', 'Direct Mail', 'direct', 'fixed', 14, 0.10);

 -- Attribution Models
INSERT INTO attribution_models
SELECT 
    model_id,
    model_name,
    model_type,
    attribution_logic,
    lookback_window,
    PARSE_JSON(channel_weights_str),
    created_at
FROM VALUES
    ('FIRST_TOUCH', 'First Touch Attribution', 'first_touch', 'First interaction gets 100% credit', 90, '{"weight": 1.0}', CURRENT_TIMESTAMP()),
    ('LAST_TOUCH', 'Last Touch Attribution', 'last_touch', 'Last interaction gets 100% credit', 30, '{"weight": 1.0}', CURRENT_TIMESTAMP()),
    ('LINEAR', 'Linear Attribution', 'linear', 'Equal credit to all interactions', 90, '{"weight": "equal"}', CURRENT_TIMESTAMP()),
    ('TIME_DECAY', 'Time Decay Attribution', 'time_decay', 'More recent interactions get more credit', 90, '{"decay_rate": 0.7}', CURRENT_TIMESTAMP())
AS t(model_id, model_name, model_type, attribution_logic, lookback_window, channel_weights_str, created_at);

-- Customer Segments
INSERT INTO customer_segments
SELECT 
    segment_id,
    segment_name,
    segment_description,
    PARSE_JSON(segment_criteria_str),
    segment_size,
    avg_ltv,
    avg_churn_risk,
    priority_score,
    created_date,
    last_updated,
    created_by,
    status
FROM VALUES
    ('HIGH_VALUE_AUTO', 'High-Value Auto Customers', 'Customers with high-end auto policies and expansion potential', '{"min_premium": 1000, "product": "auto", "income": ">75000"}', 2500, 15000.00, 0.15, 9, CURRENT_DATE(), CURRENT_DATE(), 'data_team', 'active'),
    ('YOUNG_PROFESSIONALS', 'Young Professionals', 'Ages 25-35, college educated, urban/suburban', '{"age_range": "25-35", "education": "college+", "location": "urban"}', 5200, 8500.00, 0.25, 8, CURRENT_DATE(), CURRENT_DATE(), 'data_team', 'active'),
    ('FAMILY_SEGMENT', 'Growing Families', 'Married couples with children, multiple policy potential', '{"marital_status": "married", "has_children": true}', 3800, 12000.00, 0.18, 9, CURRENT_DATE(), CURRENT_DATE(), 'data_team', 'active'),
    ('SENIORS', 'Senior Citizens', '65+ demographic with specific insurance needs', '{"age": "65+", "retirement": true}', 2100, 6500.00, 0.35, 6, CURRENT_DATE(), CURRENT_DATE(), 'data_team', 'active'),
    ('HIGH_CHURN_RISK', 'High Churn Risk', 'Customers likely to cancel or not renew', '{"churn_score": ">0.7", "engagement": "low"}', 1500, 4200.00, 0.85, 10, CURRENT_DATE(), CURRENT_DATE(), 'data_team', 'active')
AS t(segment_id, segment_name, segment_description, segment_criteria_str, segment_size, avg_ltv, avg_churn_risk, priority_score, created_date, last_updated, created_by, status);

-- Predictive Models
INSERT INTO predictive_models
SELECT 
    model_id,
    model_name,
    model_type,
    model_algorithm,
    training_data_period,
    PARSE_JSON(feature_importance_str),
    model_accuracy,
    last_trained_date,
    model_version,
    deployment_status,
    created_at
FROM VALUES
    ('CHURN_RF_V2', 'Churn Prediction - Random Forest v2.0', 'churn_prediction', 'Random Forest', '24 months', '{"payment_history": 0.25, "engagement": 0.20, "claims": 0.15, "tenure": 0.12}', 0.8745, DATEADD('day', -30, CURRENT_DATE()), '2.0', 'production', CURRENT_TIMESTAMP()),
    ('CROSS_SELL_XGB', 'Cross-Sell Propensity - XGBoost', 'cross_sell', 'XGBoost', '18 months', '{"current_products": 0.30, "demographics": 0.25, "behavior": 0.22}', 0.7892, DATEADD('day', -45, CURRENT_DATE()), '1.3', 'production', CURRENT_TIMESTAMP()),
    ('LTV_REGRESSION', 'Lifetime Value Prediction', 'ltv_prediction', 'Linear Regression', '36 months', '{"premium_amount": 0.35, "tenure": 0.20, "claims_ratio": 0.18}', 0.7234, DATEADD('day', -60, CURRENT_DATE()), '1.1', 'production', CURRENT_TIMESTAMP())
AS t(model_id, model_name, model_type, model_algorithm, training_data_period, feature_importance_str, model_accuracy, last_trained_date, model_version, deployment_status, created_at);

-- Creative Assets
INSERT INTO creative_assets
SELECT 
    creative_id, creative_name, creative_type, format, dimensions, file_size_kb, duration_seconds,
    theme, message_strategy, call_to_action, target_audience, brand_guidelines_compliant, 
    performance_score, created_date, created_by, approved_date, approved_by,
    SPLIT(tags_str, ','), -- Convert comma-separated string to array
    creative_url, created_at
FROM VALUES
    ('VID_AUTO_001', 'Auto Insurance Hero Video', 'video', 'mp4', '1920x1080', 25600, 30, 'Protection', 'Peace of mind for your daily drive', 'Get Quote', 'Auto shoppers 25-45', TRUE, 0.78, DATEADD('day', -90, CURRENT_DATE()), 'creative_team', DATEADD('day', -85, CURRENT_DATE()), 'brand_manager', 'auto,video,hero', 'https://assets.insurance.com/video/auto_001.mp4', CURRENT_TIMESTAMP()),
    ('BANNER_HOME_002', 'Home Insurance Display Banner', 'display_banner', 'jpg', '300x250', 45, NULL, 'Security', 'Protect what matters most', 'Learn More', 'Homeowners 30-60', TRUE, 0.65, DATEADD('day', -120, CURRENT_DATE()), 'creative_team', DATEADD('day', -115, CURRENT_DATE()), 'brand_manager', 'home,display,awareness', 'https://assets.insurance.com/banners/home_002.jpg', CURRENT_TIMESTAMP())
AS t(creative_id, creative_name, creative_type, format, dimensions, file_size_kb, duration_seconds, theme, message_strategy, call_to_action, target_audience, brand_guidelines_compliant, performance_score, created_date, created_by, approved_date, approved_by, tags_str, creative_url, created_at);

-- ============================================================================
-- CUSTOMER DATA - Diverse profiles for segmentation analysis
-- ============================================================================

INSERT INTO customers VALUES
-- High-value customers with cross-sell opportunities
('CUST_001', 'active', '2022-03-15', 'Sarah', 'Johnson', 'sarah.johnson@email.com', '555-0101', '1985-07-22', 'F', 'married', 95000.00, 'bachelor', 'employed', 'software_engineer', '123 Oak St', 'Austin', 'TX', '78701', 780, 'low', 18500.00, 0.12, '2024-08-15', 1, 'email', 0.85, 'AGT_001', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

('CUST_002', 'active', '2021-11-08', 'Michael', 'Chen', 'michael.chen@email.com', '555-0102', '1978-03-10', 'M', 'married', 120000.00, 'master', 'employed', 'marketing_director', '456 Pine Ave', 'Seattle', 'WA', '98101', 820, 'low', 24500.00, 0.08, '2024-09-01', 2, 'phone', 0.72, 'AGT_002', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Young professionals - cross-sell potential
('CUST_003', 'active', '2023-01-20', 'Emily', 'Rodriguez', 'emily.r@email.com', '555-0103', '1995-12-05', 'F', 'single', 68000.00, 'bachelor', 'employed', 'graphic_designer', '789 Main St', 'Denver', 'CO', '80202', 720, 'medium', 8500.00, 0.22, '2024-07-20', 1, 'text', 0.92, 'AGT_003', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- High churn risk customers
('CUST_004', 'active', '2020-05-12', 'David', 'Wilson', 'david.wilson@email.com', '555-0104', '1962-09-18', 'M', 'divorced', 45000.00, 'high_school', 'retired', 'retired', '321 Elm St', 'Phoenix', 'AZ', '85001', 650, 'medium', 3200.00, 0.78, '2024-03-10', 1, 'phone', 0.25, 'AGT_001', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

('CUST_005', 'active', '2019-08-30', 'Lisa', 'Thompson', 'lisa.t@email.com', '555-0105', '1988-04-25', 'F', 'single', 52000.00, 'bachelor', 'employed', 'teacher', '654 Cedar Rd', 'Miami', 'FL', '33101', 680, 'high', 4800.00, 0.82, '2024-02-15', 1, 'email', 0.18, 'AGT_004', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Premium customers with multiple policies
('CUST_006', 'active', '2018-12-03', 'Robert', 'Anderson', 'robert.anderson@email.com', '555-0106', '1975-11-30', 'M', 'married', 150000.00, 'master', 'employed', 'consultant', '987 Birch Ln', 'Chicago', 'IL', '60601', 850, 'low', 35000.00, 0.05, '2024-09-05', 3, 'email', 0.68, 'AGT_005', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Prospects for conversion
('CUST_007', 'prospect', NULL, 'Jennifer', 'Lee', 'jennifer.lee@email.com', '555-0107', '1992-06-15', 'F', 'single', 72000.00, 'bachelor', 'employed', 'nurse', '147 Maple Ave', 'Portland', 'OR', '97201', 740, 'low', 0.00, 0.35, NULL, 0, 'email', 0.78, 'AGT_002', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

('CUST_008', 'prospect', NULL, 'James', 'Garcia', 'james.garcia@email.com', '555-0108', '1983-01-28', 'M', 'married', 85000.00, 'bachelor', 'employed', 'accountant', '258 Spruce St', 'Atlanta', 'GA', '30301', 760, 'medium', 0.00, 0.45, NULL, 0, 'phone', 0.55, 'AGT_003', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Lapsed customers for win-back analysis
('CUST_009', 'lapsed', '2019-02-14', 'Michelle', 'Davis', 'michelle.davis@email.com', '555-0109', '1980-10-08', 'F', 'divorced', 58000.00, 'bachelor', 'employed', 'sales_rep', '369 Willow Dr', 'Dallas', 'TX', '75201', 690, 'medium', 7500.00, 0.95, '2023-11-30', 0, 'email', 0.12, 'AGT_001', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

('CUST_010', 'active', '2021-07-19', 'Christopher', 'Brown', 'chris.brown@email.com', '555-0110', '1969-05-12', 'M', 'married', 110000.00, 'master', 'employed', 'engineer', '741 Poplar St', 'San Diego', 'CA', '92101', 800, 'low', 22000.00, 0.15, '2024-08-30', 2, 'phone', 0.60, 'AGT_005', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- ============================================================================
-- CUSTOMER POLICIES - Demonstrating cross-sell opportunities
-- ============================================================================

INSERT INTO customer_policies VALUES
-- Single policy holders (cross-sell opportunities)
('POL_001', 'CUST_001', 'AUTO_FULL', 'active', '2022-03-15', '2025-03-15', 1200.00, 50000.00, 1000.00, 'monthly', TRUE, 0, '2024-08-15', '2025-03-15', 'digital', 'CAMP_001', CURRENT_TIMESTAMP()),
('POL_002', 'CUST_003', 'AUTO_BASIC', 'active', '2023-01-20', '2024-01-20', 800.00, 25000.00, 500.00, 'monthly', TRUE, 1, '2024-08-20', '2025-01-20', 'social', 'CAMP_002', CURRENT_TIMESTAMP()),
('POL_003', 'CUST_004', 'AUTO_BASIC', 'active', '2020-05-12', '2025-05-12', 750.00, 20000.00, 1000.00, 'quarterly', FALSE, 2, '2024-05-15', '2025-05-12', 'agent', NULL, CURRENT_TIMESTAMP()),
('POL_004', 'CUST_005', 'HOME_BASIC', 'active', '2019-08-30', '2024-08-30', 900.00, 150000.00, 2500.00, 'annually', FALSE, 3, '2023-08-30', '2024-08-30', 'referral', NULL, CURRENT_TIMESTAMP()),

-- Multi-policy holders (upsell opportunities)
('POL_005', 'CUST_002', 'AUTO_FULL', 'active', '2021-11-08', '2024-11-08', 1200.00, 75000.00, 1000.00, 'monthly', TRUE, 0, '2024-08-08', '2024-11-08', 'digital', 'CAMP_001', CURRENT_TIMESTAMP()),
('POL_006', 'CUST_002', 'HOME_PREMIUM', 'active', '2022-03-20', '2025-03-20', 1500.00, 300000.00, 2000.00, 'monthly', TRUE, 1, '2024-08-20', '2025-03-20', 'cross_sell', 'CAMP_003', CURRENT_TIMESTAMP()),

('POL_007', 'CUST_006', 'AUTO_FULL', 'active', '2018-12-03', '2024-12-03', 1350.00, 100000.00, 500.00, 'quarterly', TRUE, 0, '2024-09-03', '2024-12-03', 'agent', NULL, CURRENT_TIMESTAMP()),
('POL_008', 'CUST_006', 'HOME_PREMIUM', 'active', '2019-06-15', '2025-06-15', 1800.00, 500000.00, 1000.00, 'quarterly', TRUE, 0, '2024-06-15', '2025-06-15', 'cross_sell', 'CAMP_003', CURRENT_TIMESTAMP()),
('POL_009', 'CUST_006', 'LIFE_WHOLE', 'active', '2020-01-10', '2030-01-10', 950.00, 250000.00, 0.00, 'annually', TRUE, 0, '2024-01-10', '2025-01-10', 'cross_sell', 'CAMP_004', CURRENT_TIMESTAMP()),

('POL_010', 'CUST_010', 'AUTO_FULL', 'active', '2021-07-19', '2024-07-19', 1150.00, 60000.00, 750.00, 'monthly', TRUE, 1, '2024-07-19', '2024-07-19', 'agent', NULL, CURRENT_TIMESTAMP()),
('POL_011', 'CUST_010', 'HOME_BASIC', 'active', '2022-02-28', '2025-02-28', 1000.00, 200000.00, 2000.00, 'monthly', TRUE, 0, '2024-08-28', '2025-02-28', 'cross_sell', 'CAMP_003', CURRENT_TIMESTAMP()),

-- Lapsed policy (churn example)
('POL_012', 'CUST_009', 'AUTO_BASIC', 'lapsed', '2019-02-14', '2023-02-14', 850.00, 30000.00, 1000.00, 'quarterly', FALSE, 4, '2022-11-14', '2023-02-14', 'agent', NULL, CURRENT_TIMESTAMP());

-- ============================================================================
-- MARKETING CAMPAIGNS - Various types and performance levels
-- ============================================================================

INSERT INTO marketing_campaigns
SELECT 
    campaign_id, campaign_name, campaign_type, campaign_objective,
    SPLIT(target_product_ids_str, ','), -- Convert to array
    SPLIT(target_segments_str, ','), -- Convert to array  
    channel_mix, start_date, end_date, total_budget, planned_impressions, planned_clicks, 
    planned_conversions, planned_revenue, campaign_status, created_by, created_at
FROM VALUES
    ('CAMP_001', 'Digital Auto Acquisition Q3', 'acquisition', 'Acquire new auto insurance customers through digital channels', 'AUTO_BASIC,AUTO_FULL', 'YOUNG_PROFESSIONALS,FAMILY_SEGMENT', 'digital', '2024-07-01', '2024-09-30', 150000.00, 2500000, 125000, 2500, 3750000.00, 'active', 'marketing_manager', CURRENT_TIMESTAMP()),
    ('CAMP_002', 'Social Media Awareness Campaign', 'acquisition', 'Build brand awareness among young demographics', 'AUTO_BASIC,HEALTH_BASIC', 'YOUNG_PROFESSIONALS', 'digital', '2024-06-01', '2024-08-31', 75000.00, 5000000, 250000, 1200, 1800000.00, 'completed', 'marketing_manager', CURRENT_TIMESTAMP()),
    ('CAMP_003', 'Home Insurance Cross-Sell', 'cross_sell', 'Sell home insurance to existing auto customers', 'HOME_BASIC,HOME_PREMIUM', 'HIGH_VALUE_AUTO,FAMILY_SEGMENT', 'mixed', '2024-05-15', '2024-11-15', 100000.00, 800000, 40000, 1800, 4500000.00, 'active', 'marketing_manager', CURRENT_TIMESTAMP()),
    ('CAMP_004', 'Life Insurance Upsell', 'upsell', 'Promote life insurance to high-value existing customers', 'LIFE_TERM,LIFE_WHOLE', 'HIGH_VALUE_AUTO,FAMILY_SEGMENT', 'agent', '2024-04-01', '2024-12-31', 50000.00, 200000, 15000, 800, 2400000.00, 'active', 'marketing_manager', CURRENT_TIMESTAMP()),
    ('CAMP_005', 'Churn Prevention Campaign', 'retention', 'Retain at-risk customers through targeted offers', 'AUTO_BASIC,HOME_BASIC', 'HIGH_CHURN_RISK', 'mixed', '2024-08-01', '2024-10-31', 80000.00, 500000, 25000, 900, 1800000.00, 'active', 'marketing_manager', CURRENT_TIMESTAMP())
AS t(campaign_id, campaign_name, campaign_type, campaign_objective, target_product_ids_str, target_segments_str, channel_mix, start_date, end_date, total_budget, planned_impressions, planned_clicks, planned_conversions, planned_revenue, campaign_status, created_by, created_at);

-- ============================================================================
-- CAMPAIGN FORECASTS AND BUDGETS
-- ============================================================================

INSERT INTO campaign_forecasts VALUES
('FORE_001', 'CAMP_001', '2024-07-01', 'monthly', 50000.00, 833333, 41667, 833, 208, 1250000.00, 0.75, 'regression', CURRENT_TIMESTAMP()),
('FORE_002', 'CAMP_001', '2024-08-01', 'monthly', 50000.00, 833333, 41667, 833, 208, 1250000.00, 0.78, 'regression', CURRENT_TIMESTAMP()),
('FORE_003', 'CAMP_001', '2024-09-01', 'monthly', 50000.00, 833334, 41666, 834, 209, 1250000.00, 0.72, 'regression', CURRENT_TIMESTAMP()),
('FORE_004', 'CAMP_003', '2024-05-01', 'quarterly', 25000.00, 200000, 10000, 450, 112, 1125000.00, 0.82, 'ml_model', CURRENT_TIMESTAMP());

INSERT INTO budget_planning VALUES
('BUD_001', 2024, 3, 7, 'GOOGLE_ADS', 'auto', 'acquisition', 50000.00, 833333, 833, 208, 1250000.00, 60.00, 240.00, 25.00, 20.00, CURRENT_DATE(), 'marketing_manager', CURRENT_DATE(), 'finance_director'),
('BUD_002', 2024, 3, 8, 'GOOGLE_ADS', 'auto', 'acquisition', 50000.00, 833333, 833, 208, 1250000.00, 60.00, 240.00, 25.00, 20.00, CURRENT_DATE(), 'marketing_manager', CURRENT_DATE(), 'finance_director'),
('BUD_003', 2024, 3, 7, 'FACEBOOK', 'auto', 'acquisition', 25000.00, 1250000, 625, 125, 750000.00, 40.00, 200.00, 30.00, 25.00, CURRENT_DATE(), 'marketing_manager', CURRENT_DATE(), 'finance_director');

-- ============================================================================
-- AD CAMPAIGNS AND PERFORMANCE DATA
-- ============================================================================

INSERT INTO ad_campaigns VALUES
('AD_001', 'CAMP_001', 'GOOGLE_ADS', 'Auto Insurance - Search', '{"keywords": ["auto insurance", "car insurance"], "age_range": "25-45", "location": "US"}', 'daily', 1500.00, 'target_cpa', '2024-07-01', '2024-09-30', 'active', CURRENT_TIMESTAMP()),
('AD_002', 'CAMP_002', 'FACEBOOK', 'Brand Awareness - Young Adults', '{"age_range": "22-35", "interests": ["cars", "safety"], "location": "urban"}', 'lifetime', 75000.00, 'reach', '2024-06-01', '2024-08-31', 'completed', CURRENT_TIMESTAMP()),
('AD_003', 'CAMP_003', 'GOOGLE_ADS', 'Home Insurance Cross-Sell', '{"audience": "existing_customers", "product_interest": "home"}', 'daily', 800.00, 'maximize_conversions', '2024-05-15', '2024-11-15', 'active', CURRENT_TIMESTAMP());

-- Sample daily performance data (last 30 days)
INSERT INTO daily_ad_performance 
SELECT 
    'PERF_' || ROW_NUMBER() OVER (ORDER BY dates.date_val, campaigns.ad_campaign_id),
    campaigns.ad_campaign_id,
    dates.date_val,
    CASE campaigns.ad_campaign_id
        WHEN 'AD_001' THEN UNIFORM(8000, 12000, RANDOM())
        WHEN 'AD_002' THEN UNIFORM(25000, 35000, RANDOM())
        WHEN 'AD_003' THEN UNIFORM(3000, 6000, RANDOM())
    END as impressions,
    CASE campaigns.ad_campaign_id
        WHEN 'AD_001' THEN UNIFORM(400, 800, RANDOM())
        WHEN 'AD_002' THEN UNIFORM(1000, 2000, RANDOM())
        WHEN 'AD_003' THEN UNIFORM(150, 400, RANDOM())
    END as clicks,
    CASE campaigns.ad_campaign_id
        WHEN 'AD_001' THEN UNIFORM(8, 25, RANDOM())
        WHEN 'AD_002' THEN UNIFORM(5, 15, RANDOM())
        WHEN 'AD_003' THEN UNIFORM(6, 20, RANDOM())
    END as conversions,
    CASE campaigns.ad_campaign_id
        WHEN 'AD_001' THEN UNIFORM(1200.00, 1800.00, RANDOM())
        WHEN 'AD_002' THEN UNIFORM(800.00, 1200.00, RANDOM())
        WHEN 'AD_003' THEN UNIFORM(600.00, 1000.00, RANDOM())
    END as spend,
    0.0 as cost_per_click, -- Will be calculated
    0.0 as cost_per_conversion, -- Will be calculated
    0.0 as click_through_rate, -- Will be calculated
    0.0 as conversion_rate, -- Will be calculated
    0 as reach,
    0.0 as frequency,
    0 as video_views,
    0.0 as video_completion_rate,
    0.0 as engagement_rate,
    UNIFORM(6.5, 9.5, RANDOM()) as quality_score,
    CURRENT_TIMESTAMP()
FROM 
    (SELECT DATEADD('day', SEQ4(), DATEADD('day', -30, CURRENT_DATE())) as date_val
     FROM TABLE(GENERATOR(ROWCOUNT => 30))) dates
CROSS JOIN 
    (SELECT ad_campaign_id FROM ad_campaigns WHERE campaign_status = 'active') campaigns;

-- Update calculated fields
UPDATE daily_ad_performance 
SET 
    cost_per_click = spend / NULLIF(clicks, 0),
    cost_per_conversion = spend / NULLIF(conversions, 0),
    click_through_rate = clicks::FLOAT / NULLIF(impressions, 0),
    conversion_rate = conversions::FLOAT / NULLIF(clicks, 0),
    reach = impressions * 0.75, -- Approximate reach
    frequency = impressions::FLOAT / NULLIF(reach, 0);

-- ============================================================================
-- LEADS AND CRM DATA
-- ============================================================================

INSERT INTO leads
SELECT 
    lead_id, customer_id, lead_source, lead_medium, campaign_id, ad_campaign_id, lead_status, lead_score,
    SPLIT(product_interest_str, ','), -- Convert to array
    contact_preference, urgency_level, lead_value_estimate, first_contact_date, last_contact_date,
    conversion_date, days_to_conversion, assigned_agent_id, created_at, updated_at
FROM VALUES
    -- High-quality leads from digital campaigns
    ('LEAD_001', 'CUST_007', 'google_ads', 'search', 'CAMP_001', 'AD_001', 'qualified', 85, 'auto', 'email', 'high', 1200.00, '2024-08-15', '2024-08-20', NULL, NULL, 'AGT_002', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
    ('LEAD_002', 'CUST_008', 'facebook', 'social', 'CAMP_002', 'AD_002', 'nurturing', 72, 'auto,home', 'phone', 'medium', 1800.00, '2024-08-10', '2024-08-18', NULL, NULL, 'AGT_003', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
    -- Converted leads
    ('LEAD_003', 'CUST_001', 'google_ads', 'search', 'CAMP_001', 'AD_001', 'converted', 90, 'auto', 'email', 'high', 1200.00, '2022-03-10', '2022-03-15', '2022-03-15', 5, 'AGT_001', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
    ('LEAD_004', 'CUST_002', 'referral', 'word_of_mouth', NULL, NULL, 'converted', 95, 'auto,home', 'phone', 'high', 2500.00, '2021-11-05', '2021-11-08', '2021-11-08', 3, 'AGT_002', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
    -- Cross-sell leads  
    ('LEAD_005', 'CUST_001', 'email', 'cross_sell_campaign', 'CAMP_003', NULL, 'qualified', 78, 'home', 'email', 'medium', 1500.00, '2024-08-25', '2024-08-28', NULL, NULL, 'AGT_001', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
    ('LEAD_006', 'CUST_003', 'email', 'cross_sell_campaign', 'CAMP_003', NULL, 'contacted', 65, 'home', 'text', 'low', 900.00, '2024-08-20', '2024-08-22', NULL, NULL, 'AGT_003', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
    -- Lost leads for analysis
    ('LEAD_007', 'CUST_009', 'direct_mail', 'traditional', 'CAMP_005', NULL, 'lost', 45, 'auto', 'phone', 'low', 800.00, '2024-08-01', '2024-08-05', NULL, NULL, 'AGT_001', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP())
AS t(lead_id, customer_id, lead_source, lead_medium, campaign_id, ad_campaign_id, lead_status, lead_score, product_interest_str, contact_preference, urgency_level, lead_value_estimate, first_contact_date, last_contact_date, conversion_date, days_to_conversion, assigned_agent_id, created_at, updated_at);

-- Lead Activities
INSERT INTO lead_activities VALUES
('ACT_001', 'LEAD_001', 'email_open', '2024-08-16 09:30:00', 'email', 'AGT_002', 'opened', 'Customer opened follow-up email', 'schedule_call', CURRENT_TIMESTAMP()),
('ACT_002', 'LEAD_001', 'call', '2024-08-18 14:20:00', 'phone', 'AGT_002', 'interested', 'Customer expressed strong interest in full coverage', 'send_quote', CURRENT_TIMESTAMP()),
('ACT_003', 'LEAD_002', 'email_click', '2024-08-12 11:15:00', 'email', 'AGT_003', 'clicked', 'Clicked on home insurance information', 'follow_up_call', CURRENT_TIMESTAMP()),
('ACT_004', 'LEAD_005', 'meeting', '2024-08-28 16:00:00', 'video', 'AGT_001', 'positive', 'Customer interested in bundling home with existing auto', 'send_bundle_quote', CURRENT_TIMESTAMP());

-- ============================================================================
-- WEB ANALYTICS DATA
-- ============================================================================

INSERT INTO website_sessions VALUES
('SESS_001', 'CUST_001', 'VIS_001', '2024-08-15 08:30:00', '2024-08-15 08:45:00', 5, 900, FALSE, 'google', 'cpc', 'auto_insurance_campaign', 'desktop', 'chrome', 'windows', 'US', 'TX', 'Austin', FALSE, TRUE, 1, CURRENT_TIMESTAMP()),
('SESS_002', 'CUST_003', 'VIS_002', '2024-08-20 19:22:00', '2024-08-20 19:35:00', 8, 780, FALSE, 'facebook', 'social', 'awareness_campaign', 'mobile', 'safari', 'ios', 'US', 'CO', 'Denver', TRUE, FALSE, 0, CURRENT_TIMESTAMP()),
('SESS_003', 'CUST_007', 'VIS_003', '2024-08-25 12:15:00', '2024-08-25 12:32:00', 6, 1020, FALSE, 'email', 'email', 'cross_sell_home', 'desktop', 'firefox', 'mac', 'US', 'OR', 'Portland', FALSE, TRUE, 2, CURRENT_TIMESTAMP()),
('SESS_004', NULL, 'VIS_004', '2024-08-28 16:45:00', '2024-08-28 16:47:00', 2, 120, TRUE, 'direct', 'none', NULL, 'mobile', 'chrome', 'android', 'US', 'CA', 'Los Angeles', TRUE, FALSE, 0, CURRENT_TIMESTAMP());

INSERT INTO website_events
SELECT 
    event_id,
    session_id,
    customer_id,
    event_timestamp,
    event_category,
    event_action,
    event_label,
    page_url,
    page_title,
    PARSE_JSON(custom_dimensions_str),
    event_value,
    created_at
FROM VALUES
    ('EVT_001', 'SESS_001', 'CUST_001', '2024-08-15 08:35:00', 'engagement', 'quote_start', 'auto_quote', '/quote/auto', 'Auto Insurance Quote', '{"product_type": "auto", "coverage_level": "full"}', 0, CURRENT_TIMESTAMP()),
    ('EVT_002', 'SESS_001', 'CUST_001', '2024-08-15 08:42:00', 'conversion', 'quote_complete', 'auto_quote', '/quote/auto/complete', 'Quote Completed', '{"quote_amount": 1200.00}', 1200.00, CURRENT_TIMESTAMP()),
    ('EVT_003', 'SESS_002', 'CUST_003', '2024-08-20 19:28:00', 'engagement', 'page_view', 'product_page', '/products/auto', 'Auto Insurance Products', '{"time_on_page": 180}', 0, CURRENT_TIMESTAMP()),
    ('EVT_004', 'SESS_003', 'CUST_007', '2024-08-25 12:25:00', 'engagement', 'calculator_use', 'savings_calculator', '/tools/savings', 'Bundle Savings Calculator', '{"potential_savings": 250.00}', 250.00, CURRENT_TIMESTAMP()),
    ('EVT_005', 'SESS_003', 'CUST_007', '2024-08-25 12:30:00', 'conversion', 'contact_form', 'contact_request', '/contact', 'Contact Form Submission', '{"interest": "home_insurance"}', 0, CURRENT_TIMESTAMP())
AS t(event_id, session_id, customer_id, event_timestamp, event_category, event_action, event_label, page_url, page_title, custom_dimensions_str, event_value, created_at);

-- ============================================================================
-- EMAIL CAMPAIGNS
-- ============================================================================

INSERT INTO email_campaigns VALUES
('EMAIL_001', 'CAMP_003', 'Bundle and Save: Add Home Insurance', 'promotional', '2024-08-15', 15000, 14250, 4275, 342, 28, 45, 2, 0.30, 0.08, 0.082, CURRENT_TIMESTAMP()),
('EMAIL_002', 'CAMP_005', 'We Miss You - Special Offer Inside', 'retention', '2024-08-20', 2500, 2375, 855, 68, 12, 78, 5, 0.36, 0.08, 0.176, CURRENT_TIMESTAMP()),
('EMAIL_003', 'CAMP_001', 'Get Your Auto Quote in Under 5 Minutes', 'promotional', '2024-08-10', 25000, 24000, 7200, 576, 45, 125, 8, 0.30, 0.08, 0.078, CURRENT_TIMESTAMP());

-- ============================================================================
-- CUSTOMER TOUCHPOINTS AND JOURNEY DATA
-- ============================================================================

INSERT INTO customer_touchpoints VALUES
('TOUCH_001', 'CUST_001', 'SESS_001', '2024-08-15 08:30:00', 'google_ads', 'CAMP_001', 'AD_001', 'consideration', 0.75, 'auto_quote_page', 0.85, 1, CURRENT_TIMESTAMP()),
('TOUCH_002', 'CUST_001', NULL, '2024-08-16 09:30:00', 'email', 'CAMP_001', NULL, 'consideration', 0.60, 'follow_up_email', 0.70, 2, CURRENT_TIMESTAMP()),
('TOUCH_003', 'CUST_001', NULL, '2024-08-18 14:20:00', 'phone', 'CAMP_001', NULL, 'purchase', 0.90, 'sales_call', 0.95, 3, CURRENT_TIMESTAMP()),
('TOUCH_004', 'CUST_003', 'SESS_002', '2024-08-20 19:22:00', 'facebook', 'CAMP_002', 'AD_002', 'awareness', 0.40, 'brand_video', 0.50, 1, CURRENT_TIMESTAMP()),
('TOUCH_005', 'CUST_007', 'SESS_003', '2024-08-25 12:15:00', 'email', 'CAMP_003', NULL, 'consideration', 0.70, 'cross_sell_offer', 0.80, 1, CURRENT_TIMESTAMP());

-- ============================================================================
-- ATTRIBUTION RESULTS
-- ============================================================================

INSERT INTO attribution_results VALUES
('ATTR_001', 'CUST_001', 'POL_001', 'FIRST_TOUCH', 'TOUCH_001', 'google_ads', 'CAMP_001', 1.0, 1200.00, '2022-03-15', CURRENT_TIMESTAMP()),
('ATTR_002', 'CUST_002', 'POL_005', 'LINEAR', 'TOUCH_003', 'phone', 'CAMP_001', 0.33, 400.00, '2021-11-08', CURRENT_TIMESTAMP()),
('ATTR_003', 'CUST_002', 'POL_006', 'LAST_TOUCH', 'TOUCH_005', 'email', 'CAMP_003', 1.0, 1500.00, '2022-03-20', CURRENT_TIMESTAMP()),
('ATTR_004', 'CUST_006', 'POL_009', 'TIME_DECAY', 'TOUCH_003', 'phone', 'CAMP_004', 0.7, 665.00, '2020-01-10', CURRENT_TIMESTAMP());

-- ============================================================================
-- CUSTOMER SEGMENT MEMBERSHIP
-- ============================================================================

INSERT INTO customer_segment_membership VALUES
('MEM_001', 'CUST_001', 'HIGH_VALUE_AUTO', '2024-01-01', NULL, 0.92, CURRENT_TIMESTAMP()),
('MEM_002', 'CUST_001', 'YOUNG_PROFESSIONALS', '2022-03-15', '2024-01-01', 0.85, CURRENT_TIMESTAMP()),
('MEM_003', 'CUST_002', 'HIGH_VALUE_AUTO', '2022-06-01', NULL, 0.88, CURRENT_TIMESTAMP()),
('MEM_004', 'CUST_002', 'FAMILY_SEGMENT', '2022-06-01', NULL, 0.94, CURRENT_TIMESTAMP()),
('MEM_005', 'CUST_003', 'YOUNG_PROFESSIONALS', '2023-01-20', NULL, 0.91, CURRENT_TIMESTAMP()),
('MEM_006', 'CUST_004', 'HIGH_CHURN_RISK', '2024-06-01', NULL, 0.87, CURRENT_TIMESTAMP()),
('MEM_007', 'CUST_004', 'SENIORS', '2024-06-01', NULL, 0.89, CURRENT_TIMESTAMP()),
('MEM_008', 'CUST_005', 'HIGH_CHURN_RISK', '2024-07-01', NULL, 0.93, CURRENT_TIMESTAMP()),
('MEM_009', 'CUST_006', 'HIGH_VALUE_AUTO', '2019-01-01', NULL, 0.96, CURRENT_TIMESTAMP()),
('MEM_010', 'CUST_006', 'FAMILY_SEGMENT', '2019-01-01', NULL, 0.90, CURRENT_TIMESTAMP());

-- ============================================================================
-- PREDICTIVE MODEL RESULTS
-- ============================================================================

INSERT INTO model_predictions
SELECT 
    prediction_id,
    customer_id,
    model_id,
    prediction_date,
    prediction_value,
    confidence_interval,
    PARSE_JSON(model_features_str),
    action_recommended,
    created_at
FROM VALUES
    ('PRED_001', 'CUST_004', 'CHURN_RF_V2', CURRENT_DATE(), 0.78, '0.72-0.84', '{"payment_delays": 2, "engagement_score": 0.25, "claims_count": 2}', 'retention_offer', CURRENT_TIMESTAMP()),
    ('PRED_002', 'CUST_005', 'CHURN_RF_V2', CURRENT_DATE(), 0.82, '0.78-0.86', '{"payment_delays": 1, "engagement_score": 0.18, "claims_count": 3}', 'priority_outreach', CURRENT_TIMESTAMP()),
    ('PRED_003', 'CUST_001', 'CROSS_SELL_XGB', CURRENT_DATE(), 0.85, '0.81-0.89', '{"current_products": 1, "income_level": "high", "engagement": "high"}', 'home_insurance_offer', CURRENT_TIMESTAMP()),
    ('PRED_004', 'CUST_003', 'CROSS_SELL_XGB', CURRENT_DATE(), 0.72, '0.68-0.76', '{"current_products": 1, "age_group": "young_professional", "digital_native": true}', 'renters_insurance_offer', CURRENT_TIMESTAMP()),
    ('PRED_005', 'CUST_006', 'LTV_REGRESSION', CURRENT_DATE(), 0.92, '0.88-0.96', '{"premium_amount": 4100, "tenure": 6, "claims_ratio": 0.05}', 'vip_treatment', CURRENT_TIMESTAMP())
AS t(prediction_id, customer_id, model_id, prediction_date, prediction_value, confidence_interval, model_features_str, action_recommended, created_at);

-- ============================================================================
-- ACTUAL PERFORMANCE DATA
-- ============================================================================

INSERT INTO actual_performance VALUES
('ACT_001', 'BUD_001', '2024-07-31', 52000.00, 825000, 820, 205, 1230000.00, 4.00, -1.56, -1.60, 63.41, 253.66, 23.65, 18.67, CURRENT_TIMESTAMP()),
('ACT_002', 'BUD_002', '2024-08-31', 48500.00, 850000, 865, 215, 1285000.00, -3.00, 3.84, 2.80, 56.07, 225.58, 26.49, 21.52, CURRENT_TIMESTAMP()),
('ACT_003', 'BUD_003', '2024-07-31', 26200.00, 1180000, 590, 118, 745000.00, 4.80, -5.60, -0.67, 44.41, 222.03, 28.44, 23.55, CURRENT_TIMESTAMP());

-- ============================================================================
-- MARKETING EVENTS
-- ============================================================================

INSERT INTO marketing_events VALUES
('EVT_MKT_001', 'Summer Insurance Fair', 'trade_show', '2024-08-15', 'Austin Convention Center', 'families_young_professionals', 5000, 4200, 15000.00, 180, 12, 0.80, 4.2, 'CAMP_001', CURRENT_TIMESTAMP()),
('EVT_MKT_002', 'Homebuyer Webinar Series', 'webinar', '2024-08-20', 'Virtual', 'new_homeowners', 800, 650, 5000.00, 65, 18, 3.60, 4.5, 'CAMP_003', CURRENT_TIMESTAMP()),
('EVT_MKT_003', 'Community Safety Day Sponsorship', 'sponsorship', '2024-09-01', 'Central Park', 'families_safety_conscious', 2000, 1850, 8000.00, 95, 8, 1.00, 4.1, 'CAMP_002', CURRENT_TIMESTAMP());

-- ============================================================================
-- CREATIVE PERFORMANCE DATA
-- ============================================================================

INSERT INTO ad_creative_performance VALUES
('PERF_CR_001', 'AD_001', 'VID_AUTO_001', '2024-08-15', 125000, 1250, 85, 1500.00, 0.012, 0.78, CURRENT_TIMESTAMP()),
('PERF_CR_002', 'AD_002', 'BANNER_HOME_002', '2024-08-15', 85000, 680, 28, 800.00, 0.008, 0.65, CURRENT_TIMESTAMP()),
('PERF_CR_003', 'AD_003', 'VID_AUTO_001', '2024-08-20', 95000, 950, 72, 950.00, 0.013, 0.82, CURRENT_TIMESTAMP());

-- ============================================================================
-- SUMMARY METRICS FOR VERIFICATION
-- ============================================================================

-- Create a summary view to verify data completeness
CREATE OR REPLACE VIEW data_summary AS
SELECT 
    'customers' as table_name, COUNT(*) as record_count FROM customers
UNION ALL
SELECT 'customer_policies', COUNT(*) FROM customer_policies
UNION ALL  
SELECT 'marketing_campaigns', COUNT(*) FROM marketing_campaigns
UNION ALL
SELECT 'leads', COUNT(*) FROM leads
UNION ALL
SELECT 'website_sessions', COUNT(*) FROM website_sessions
UNION ALL
SELECT 'daily_ad_performance', COUNT(*) FROM daily_ad_performance
UNION ALL
SELECT 'attribution_results', COUNT(*) FROM attribution_results
UNION ALL
SELECT 'customer_segment_membership', COUNT(*) FROM customer_segment_membership
UNION ALL
SELECT 'model_predictions', COUNT(*) FROM model_predictions;

-- Show the summary
SELECT * FROM data_summary ORDER BY table_name;

-- ============================================================================
-- ANALYTICAL QUERIES FOR VALIDATION
-- ============================================================================

-- Cross-sell opportunities
SELECT 
    customer_id,
    COUNT(DISTINCT product_category) as products_owned,
    LISTAGG(DISTINCT product_category, ', ') as current_products,
    CASE 
        WHEN COUNT(DISTINCT product_category) = 1 THEN 'High Cross-sell Potential'
        WHEN COUNT(DISTINCT product_category) = 2 THEN 'Medium Cross-sell Potential'  
        ELSE 'Limited Cross-sell Potential'
    END as cross_sell_opportunity
FROM customer_policies cp
JOIN insurance_products ip ON cp.product_id = ip.product_id
WHERE cp.policy_status = 'active'
GROUP BY customer_id
ORDER BY products_owned;

-- Churn risk analysis
SELECT 
    churn_risk_category,
    COUNT(*) as customer_count,
    AVG(lifetime_value) as avg_ltv,
    AVG(digital_engagement_score) as avg_engagement
FROM (
    SELECT *,
        CASE 
            WHEN churn_risk_score < 0.3 THEN 'Low Risk'
            WHEN churn_risk_score < 0.7 THEN 'Medium Risk'
            ELSE 'High Risk'
        END as churn_risk_category
    FROM customers
) 
GROUP BY churn_risk_category
ORDER BY customer_count DESC;

-- Campaign performance summary
SELECT 
    mc.campaign_name,
    mc.campaign_type,
    COUNT(DISTINCT l.lead_id) as leads_generated,
    COUNT(DISTINCT CASE WHEN l.lead_status = 'converted' THEN l.lead_id END) as conversions,
    DIV0(COUNT(DISTINCT CASE WHEN l.lead_status = 'converted' THEN l.lead_id END), 
         COUNT(DISTINCT l.lead_id)) as conversion_rate,
    SUM(dap.spend) as total_spend,
    DIV0(SUM(dap.spend), COUNT(DISTINCT CASE WHEN l.lead_status = 'converted' THEN l.lead_id END)) as cost_per_conversion
FROM marketing_campaigns mc
LEFT JOIN leads l ON mc.campaign_id = l.campaign_id
LEFT JOIN ad_campaigns ac ON mc.campaign_id = ac.campaign_id
LEFT JOIN daily_ad_performance dap ON ac.ad_campaign_id = dap.ad_campaign_id
GROUP BY mc.campaign_name, mc.campaign_type
ORDER BY conversion_rate DESC;


