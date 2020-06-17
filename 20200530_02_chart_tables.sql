-- Maybe add a flag for group members automatically getting group view?
CREATE TABLE chart_user_groups (
    id SERIAL PRIMARY KEY,
    group_name VARCHAR(255),
    survey_id SERIAL REFERENCES survey_surveys(id)
);

CREATE TABLE chart_user_groups_members (
    group_id SERIAL REFERENCES chart_user_groups(id) NOT NULL,
    user_id SERIAL REFERENCES survey_users(id) NOT NULL,
    UNIQUE (group_id, user_id)
);

-- TODO: better name
CREATE TABLE chart_charts_collections (
    id SERIAL PRIMARY KEY,
    survey_id SERIAL REFERENCES survey_surveys(id),
    survey_revision SERIAL REFERENCES survey_revision(id),
    chart_sections JSON,
    data_filters JSON,
    UNIQUE (survey_id, survey_revision)
);

CREATE TABLE chart_user_surveys (
    user_id SERIAL REFERENCES survey_users(id),
    survey_id SERIAL REFERENCES survey_surveys(id),
    group_id SERIAL REFERENCES chart_user_groups(id),
    charts_collections_id SERIAL REFERENCES chart_charts_collections(id),
    UNIQUE (user_id, survey_id, group_id, charts_collections_id)
);