-- getting glucose level data
WITH fbs_raw AS (
    SELECT  m.person_id, 
            m.value_source_value as value,
            m.measurement_datetime
    FROM [cdm].[measurement] m
    WHERE m.measurement_concept_id = 3004501
    AND m.measurement_datetime BETWEEN '2013-06-01' AND '2023-09-30'
    AND CAST(m.measurement_datetime AS TIME) < '10:00:00'
),

opd_visit AS (
    SELECT  v.person_id,
            v.visit_start_date
    FROM [cdm].[visit_occurrence] v
    WHERE v.visit_start_date BETWEEN '2013-06-01' AND '2023-09-30'
   AND v.visit_concept_id = 9202 
),

fbs AS (
    SELECT  f.person_id,
            f.value,
            f.measurement_datetime
    FROM fbs_raw f
    INNER JOIN opd_visit v ON f.person_id = v.person_id AND f.measurement_datetime BETWEEN v.visit_start_date AND DATEADD(DAY, 1, v.visit_start_date)
    WHERE TRY_CAST(f.value AS int) >= 126
-- inner join will remove all non-opd record
-- will fix this when measurement.visit_occurence_id is available
),

-- getting hba1c data
hba1c AS (
    SELECT  m.person_id, 
            m.value_source_value as value,
            m.measurement_datetime
    FROM [cdm].[measurement] m
    WHERE m.measurement_concept_id = 3004410
    AND TRY_CAST(m.value_source_value as DECIMAL(4,1)) >= 6.5
    AND m.measurement_datetime BETWEEN '2013-06-01' AND '2023-09-30'
),

-- getting ogtt data
-- ** this criteria have been modified from the original P'Burin cohort
-- ** because OMOP concept code for 1st step of OGTT will include other glucose level lab
-- ** so we will use OGTT >= 200 criteria at step 2, 3, 4 of OGTT instead
ogtt AS (
    SELECT  m.person_id, 
            m.value_source_value as value,
            m.measurement_datetime
    FROM [cdm].[measurement] m
    WHERE m.measurement_concept_id IN (3006717, 3014716, 3027457)
    AND m.measurement_datetime BETWEEN '2013-06-01' AND '2023-09-30'
),

fbs_crit AS (
    SELECT  f.person_id,
            f.measurement_datetime,
            f.value,
            ROW_NUMBER() OVER(PARTITION BY f.person_id ORDER BY f.measurement_datetime) as rn
    FROM fbs f
),


hba1c_crit AS (
    SELECT  h.person_id,
            h.measurement_datetime,
            h.value,
            ROW_NUMBER() OVER(PARTITION BY h.person_id ORDER BY h.measurement_datetime) as rn
    FROM hba1c h
),

fbs_hb_crit AS (
        SELECT sq.person_id,
            sq.measurement_datetime,
            ROW_NUMBER() OVER(PARTITION BY sq.person_id ORDER BY sq.measurement_datetime) as rn
        FROM (SELECT f.person_id,
                f.measurement_datetime,
                f.value as fbs_value,
                NULL as hba1c_value
                FROM fbs_crit f
                UNION ALL
                SELECT h.person_id,
                h.measurement_datetime,
                NULL as fbs_value,
                h.value as hba1c_value
            FROM hba1c_crit h) sq
),

ogtt_hn AS (
    SElECT  o.person_id, 
            MIN(o.measurement_datetime) as first_date,
            3 as lab
    FROM ogtt o
    WHERE TRY_CAST(o.value as float) >= 200
    GROUP BY o.person_id
), 

fbs_hn AS (
    SELECT person_id, 
            measurement_datetime as first_date,
            0 as lab
    FROM fbs_crit
    WHERE rn = 2
),

hba1c_hn AS (
    SELECT person_id,
            measurement_datetime as first_date,
            1 as lab
    FROM hba1c_crit
    WHERE rn = 2
),

fbs_hb_hn AS (
    SELECT person_id,
            measurement_datetime as first_date,
            2 as lab
    FROM fbs_hb_crit
    WHERE rn = 2 
) 


-- getting the final list of patients
SELECT person_id, MIN(first_date) as first_diag_datetime FROM (
    SELECT person_id, first_date, lab
    FROM fbs_hn
    UNION 
    SELECT person_id, first_date, lab
    FROM hba1c_hn
    UNION
    SELECT person_id, first_date, lab
    FROM fbs_hb_hn
    UNION
    SELECT person_id, first_date, lab
    FROM ogtt_hn
) all_hn
GROUP BY person_id





-- --------------------------------------------
-- --- Note
-- -- HbA1c Use measurement_source_value = 5099
-- -- concept = 3004410

-- -- Glucose concept = 3004501
-- -- 400317	Blood sugar
-- -- 0322	Glucose tolerance 1
-- -- 5103	Glucose heparin
-- -- 0013	Glucose (NaF)

-- -- OGTT
-- -- measurement_source_value = '0321','0322','0323','0324','0325','0326'
-- -- concept = 3014716
-- -- 3004501	0322 -- 1st step of OGTT --> means fasting glucose
-- -- 3006717	0324
-- -- 3014716	0323
-- -- 3027457	0325
