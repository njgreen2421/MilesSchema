-- Simple multiple choice question filtered by an answer to another question
SELECT answer_id, count(id) 'count' FROM question_quantitative_responses
WHERE 
    survey_id='some_survey_id' 
    AND survey_revision='some_rev' 
    AND question_id='some_question'
    AND session_id IN (
        SELECT session_id FROM question_quantitative_responses 
        WHERE
            survey_id='some_survey_id' 
            AND survey_revision='some_rev' 
            AND question_id='some_other_question'
            AND answer_id='Yes'
    )
GROUP by answer_id


-- Multiple choice question, grouped by a secondary question response (ex. age)
SELECT A.answer_id, B.answer_id 'group_answer_id', count(A.id) 'count' FROM question_quantitative_responses A
LEFT JOIN (
    SELECT session_id, answer_id FROM question_quantitative_responses 
    WHERE
        survey_id='some_survey_id' 
        AND survey_revision='some_rev' 
        AND question_id='age'
) B ON A.session_id = B.session_id
WHERE 
    A.survey_id='some_survey_id' 
    AND A.survey_revision='some_rev' 
    AND A.question_id='some_question'
GROUP by A.answer_id, group_answer_id

