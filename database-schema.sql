-- Database Schema for Business Plan Playbook
-- This schema can be used with PostgreSQL, MySQL, or adapted for other databases

-- Table: business_plan_history
-- Stores all generated prompt responses for user history

CREATE TABLE IF NOT EXISTS business_plan_history (
    id SERIAL PRIMARY KEY,
    prompt_id VARCHAR(100) NOT NULL,
    prompt_title VARCHAR(255),
    category VARCHAR(100) NOT NULL,
    inputs JSONB NOT NULL,
    response TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id VARCHAR(100),  -- Optional: for multi-user support
    
    -- Indexes for better query performance
    INDEX idx_prompt_id (prompt_id),
    INDEX idx_category (category),
    INDEX idx_timestamp (timestamp),
    INDEX idx_user_id (user_id)
);

-- Table: prompt_analytics (Optional)
-- Track usage statistics for prompts

CREATE TABLE IF NOT EXISTS prompt_analytics (
    id SERIAL PRIMARY KEY,
    prompt_id VARCHAR(100) NOT NULL,
    category VARCHAR(100) NOT NULL,
    usage_count INTEGER DEFAULT 1,
    last_used TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    average_response_time INTEGER,  -- in milliseconds
    
    UNIQUE(prompt_id),
    INDEX idx_usage_count (usage_count),
    INDEX idx_last_used (last_used)
);

-- Table: user_preferences (Optional)
-- Store user settings and preferences

CREATE TABLE IF NOT EXISTS user_preferences (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(100) UNIQUE NOT NULL,
    favorite_prompts JSONB,
    saved_templates JSONB,
    settings JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Queries

-- Get all history for a user
-- SELECT * FROM business_plan_history 
-- WHERE user_id = 'user123' 
-- ORDER BY timestamp DESC 
-- LIMIT 50;

-- Get most used prompts
-- SELECT prompt_id, category, usage_count 
-- FROM prompt_analytics 
-- ORDER BY usage_count DESC 
-- LIMIT 10;

-- Get recent responses by category
-- SELECT * FROM business_plan_history 
-- WHERE category = 'strategy' 
-- ORDER BY timestamp DESC 
-- LIMIT 20;

-- MongoDB Alternative Schema (JSON format)
-- {
--   "business_plan_history": {
--     "_id": "ObjectId",
--     "promptId": "string",
--     "promptTitle": "string",
--     "category": "string",
--     "inputs": {
--       "field1": "value1",
--       "field2": "value2"
--     },
--     "response": "string",
--     "timestamp": "ISODate",
--     "userId": "string"
--   }
-- }

-- Indexes for MongoDB:
-- db.business_plan_history.createIndex({ "promptId": 1 })
-- db.business_plan_history.createIndex({ "category": 1 })
-- db.business_plan_history.createIndex({ "timestamp": -1 })
-- db.business_plan_history.createIndex({ "userId": 1 })
