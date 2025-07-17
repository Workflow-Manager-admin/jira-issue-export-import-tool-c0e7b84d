-- Database initialization script for Jira Issue Export/Import Tool
-- This script creates the necessary tables and indexes

USE myapp;

-- Create user_sessions table
CREATE TABLE IF NOT EXISTS user_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    jira_email VARCHAR(255) NOT NULL,
    jira_token TEXT NOT NULL,
    jira_domain VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_session_token (session_token),
    INDEX idx_jira_email (jira_email),
    INDEX idx_expires_at (expires_at),
    INDEX idx_is_active (is_active)
);

-- Create projects table
CREATE TABLE IF NOT EXISTS projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    jira_project_key VARCHAR(50) NOT NULL,
    jira_project_id VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    project_type VARCHAR(100),
    lead_name VARCHAR(255),
    url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES user_sessions(id) ON DELETE CASCADE,
    INDEX idx_session_id (session_id),
    INDEX idx_jira_project_key (jira_project_key),
    INDEX idx_jira_project_id (jira_project_id),
    UNIQUE KEY unique_session_project (session_id, jira_project_key)
);

-- Create issue_types table
CREATE TABLE IF NOT EXISTS issue_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    jira_issue_type_id VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    icon_url VARCHAR(500),
    subtask BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    INDEX idx_project_id (project_id),
    INDEX idx_jira_issue_type_id (jira_issue_type_id),
    INDEX idx_subtask (subtask),
    UNIQUE KEY unique_project_issue_type (project_id, jira_issue_type_id)
);

-- Create indexes for performance
CREATE INDEX idx_user_sessions_active ON user_sessions(is_active, expires_at);
CREATE INDEX idx_projects_session_key ON projects(session_id, jira_project_key);
CREATE INDEX idx_issue_types_project_name ON issue_types(project_id, name);

-- Insert sample data or initial configurations if needed
-- This section can be used for default configurations

SELECT 'Database schema initialized successfully' as status;
