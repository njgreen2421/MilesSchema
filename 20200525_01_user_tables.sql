-- Admin users have access to the survey site and the charts site.
CREATE TABLE admin_users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    salt VARCHAR(255) UNIQUE NOT NULL
);

-- These users refer to the accounts that are accessing the charting display.
-- They are shared accounts among a school or org.
-- config stores access to groups, extra views, etc.
CREATE TABLE charts_users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    display_name VARCHAR(255),
    password VARCHAR(255) NOT NULL,
    salt VARCHAR(255) NOT NULL,
    config JSON
);