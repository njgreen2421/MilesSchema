-- init uuid functions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE survey_surveys (
    id SERIAL PRIMARY KEY,
    alias VARCHAR(255), -- do I really need this column?
    display_name TEXT, -- maybe move this (and lower) config to to survey_revisions
    settings JSON DEFAULT '{}',
    status VARCHAR(50) DEFAULT 'editing',
    start_time TIMESTAMP DEFAULT NULL,
    end_time TIMESTAMP DEFAULT NULL
);

INSERT INTO survey_surveys 
(alias, display_name, settings, status)
VALUES
('test_survey', 'Test Survey', '{}', 'editing');

-- Users in this context refers to a (generally) shared account that can take a single survey. It's a shared identifier that 
-- distinguishes the school/org that is "sharing" this account.
CREATE TABLE survey_users (
    id SERIAL PRIMARY KEY,
    survey_id SERIAL REFERENCES survey_surveys(id),
    display_name VARCHAR(255),
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    salt VARCHAR(255) UNIQUE NOT NULL
);

-- Survey revisions allow us to keep track of what the survey was like at a certain point in time.
-- Since questions will be reused, we need to track changes across different runs of the survey. 
-- This approach allows us to change the questions until/durring the run of the survey without needing
-- to update the survey/chart to use a new revision of the question.
-- We need to ensure new revisions get made for every run of a survey, as well as making a copy of all questions/answers
CREATE TABLE survey_revision (
    id SERIAL PRIMARY KEY,
    survey_id SERIAL REFERENCES survey_surveys(id),
    name VARCHAR(255) -- Not sure if this is needed
);


CREATE TABLE survey_sessions (
    id SERIAL PRIMARY KEY,
    user_id SERIAL REFERENCES survey_users(id),
    survey_id SERIAL REFERENCES survey_surveys(id),
    survey_revision SERIAL REFERENCES survey_revision(id),
    start_time TIMESTAMP,
    last_submission_time TIMESTAMP DEFAULT NULL,
    last_section_complete INT DEFAULT NULL,
    prize_drawing_entered BOOLEAN DEFAULT FALSE,
    percent_complete FLOAT(4),
    session_id uuid DEFAULT uuid_generate_v4 ()
);