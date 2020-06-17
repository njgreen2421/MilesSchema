--Maybe a "question" table with a pool of distinct questions? and this becomes a connection table that connects questions with surveys.
CREATE TABLE question_questions (
    id SERIAL PRIMARY KEY,
    survey_id SERIAL REFERENCES survey_surveys(id),
    survey_revision SERIAL REFERENCES survey_revision(id),--is this needed?
    question_text TEXT,
    question_type VARCHAR(255),--Question Types table?
    deleted BOOLEAN DEFAULT FALSE,
    config JSON
);

-- Maybe I should include the order_index in question_questions.config
--Maybe make a discrete answers table and make this a "connection" table that connects questions to answers.  
--If we have an Answer to a Yes No question, we may end up with many different rows in this table with Yes or No in answer_display?
--I'm assuming predefined answers and not-free-form user input.  (it looks like this assumption is validated by question_quantitative_responses below)
--Also do we need all these IDs? seems we just need question_id? the survey revision/survery_id are properties of the question, not the answer
CREATE TABLE question_answers (
    id SERIAL PRIMARY KEY,
    survey_id SERIAL REFERENCES survey_surveys(id),--is this needed?
    survey_revision SERIAL REFERENCES survey_revision(id),--is this needed?
    question_id SERIAL REFERENCES question_questions(id),
    answer_display VARCHAR(255),
    order_index SMALLINT,
    deleted BOOLEAN DEFAULT FALSE
);

--Is this table needed? I don't know if I understand its purpose, is it to order the questions? could we move order_index to the question_questions table?
--
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
--
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