-- User tables
CREATE TABLE admin_users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    salt VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE charts_users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    display_name VARCHAR(255),
    password VARCHAR(255) NOT NULL,
    salt VARCHAR(255) NOT NULL
);