WITH desc_condition AS ( -- All descendants of the 201826 T2DM SNOMED concept
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id = 201826 -- base query 
),

desc_complication AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id = 443732 -- base query 
),

desc_con AS (
    SELECT descendant_concept_id
    FROM desc_condition
    UNION
    SELECT descendant_concept_id
    FROM desc_complication
),

p_info AS ( -- Get patients info
    SELECT p.person_id, p.year_of_birth
    FROM cdm.person p
),

diag_info AS ( -- get the first diagnosis of T2DM for each patient
    SELECT  co.person_id,
            co.condition_concept_id,
            MIN(co.condition_start_datetime) AS first_diag,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_datetime) as rn
    FROM cdm.condition_occurrence co
    JOIN desc_con d ON co.condition_concept_id = d.descendant_concept_id
    WHERE co.condition_start_datetime BETWEEN '2013-06-01' AND '2023-09-30'
    GROUP BY co.person_id, co.condition_concept_id, co.condition_start_datetime
)

SELECT  d.person_id,
        d.condition_concept_id,
        (YEAR(d.first_diag) - p.year_of_birth) AS age_at_first_diag
FROM diag_info d
JOIN p_info p ON d.person_id = p.person_id
WHERE d.rn = 1