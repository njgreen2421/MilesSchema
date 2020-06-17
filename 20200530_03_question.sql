CREATE TABLE question_questions (
    id SERIAL PRIMARY KEY,
    survey_id SERIAL REFERENCES survey_surveys(id),
    survey_revision SERIAL REFERENCES survey_revision(id),
    question_text TEXT,
    question_type VARCHAR(255),
    deleted BOOLEAN DEFAULT FALSE,
    config JSON
);

-- Maybe I should include the order_index in question_questions.config
CREATE TABLE question_answers (
    id SERIAL PRIMARY KEY,
    survey_id SERIAL REFERENCES survey_surveys(id),
    survey_revision SERIAL REFERENCES survey_revision(id),
    question_id SERIAL REFERENCES question_questions(id),
    answer_display VARCHAR(255),
    order_index SMALLINT,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE question_rows (
    id SERIAL PRIMARY KEY,
    survey_id SERIAL REFERENCES survey_surveys(id),
    survey_revision SERIAL REFERENCES survey_revision(id),
    question_id SERIAL REFERENCES question_questions(id),
    order_index SMALLINT
);

-- Having a question_id and question_row_id is enough to store 2D data (rows of checkboxes) with multiple entries in this table
-- In scarce tables with 8 or fewer columns, NULL occupies 0 bytes
-- https://stackoverflow.com/a/12147130
CREATE TABLE question_quantitative_responses (
    id SERIAL PRIMARY KEY,
    survey_id SERIAL REFERENCES survey_surveys(id),
    survey_revision SERIAL REFERENCES survey_revision(id),
    session_id SERIAL REFERENCES survey_sessions(id),
    question_id SERIAL REFERENCES question_questions(id),
    question_row_id SERIAL REFERENCES question_rows(id),
    answer_id SERIAL REFERENCES question_answers(id),
    -- Disallow dupliacte answers for the same user, but allow for multiple answers in a row
    UNIQUE(session_id, question_id, question_row_id)
);

CREATE TABLE question_qualitative_responses (
    id SERIAL PRIMARY KEY,
    survey_id SERIAL REFERENCES survey_surveys(id),
    survey_revision SERIAL REFERENCES survey_revision(id),
    session_id SERIAL REFERENCES survey_sessions(id),
    question_id SERIAL REFERENCES question_questions(id),
    answer TEXT,
    UNIQUE(session_id, question_id)
);