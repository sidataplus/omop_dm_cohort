WITH pt AS (
    SELECT person_id,
            year_of_birth
    FROM cdm.person
    WHERE person_id IN (INSERT_PERSON_ID_LIST)
),
------------------Comorbidities--------------------------------
-- -- T2DM
-- dm_code AS (
--     -- All descendants of the 201826 T2DM SNOMED concept
--     SELECT c.descendant_concept_id
--     FROM vocab.concept_ancestor c
--     WHERE c.ancestor_concept_id = 201826 -- base query
--     AND c.descendant_concept_id != 4063043 -- we have to remove pre-diabetes code
--     UNION
--     SELECT c.descendant_concept_id
--     FROM vocab.concept_ancestor c
--     WHERE c.ancestor_concept_id = 443732 -- for T2DM complications
--     UNION
--     SELECT (443735) -- manually Added missing ICD10 equivalent "E110" code : "Type 2 diabetes mellitus with hyperosmolarity without nonketotic hyperglycemic-hyperosmolar coma"
-- ),
-- dm_all_dx AS (
--     SELECT  co.person_id,
--             co.condition_concept_id,
--             co.condition_start_date,
--             co.condition_source_value,
--             ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
--     FROM cdm.condition_occurrence co
--     WHERE condition_concept_id in (SELECT * FROM dm_code)
-- ),
-- dm_first_dx AS (
--     SELECT person_id,
--             condition_concept_id,
--             condition_start_date,
--             condition_source_value
--     FROM dm_all_dx
--     WHERE rn = 1
-- ),

-- essential hypertension
ht_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id = 320128
),
ht_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM ht_code)
),
ht_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM ht_all_dx
    WHERE rn = 1
),

--hyperlipidemia
dlp_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id = 432867
),
dlp_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM dlp_code)
),
dlp_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM dlp_all_dx
    WHERE rn = 1
),

--Atrial fibrillation
af_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id = 4068155
),
af_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM af_code)
),
af_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM af_all_dx
    WHERE rn = 1
),
---------------Charlson---------------------------------------
--Acute myocardial infarction
ami_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id = 4329847
),
ami_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM ami_code)
),
ami_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM ami_all_dx
    WHERE rn = 1
),

--Congestive heart failure
chf_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id = 316139
),
chf_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM chf_code)
),
chf_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM chf_all_dx
    WHERE rn = 1
),

--Peripheral vascular disease
pvd_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id = 321052
),
pvd_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM pvd_code)
),
pvd_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM pvd_all_dx
    WHERE rn = 1
),

--Cerebrovascular disease
cvd_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id IN (381591, 434056)
),
cvd_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM cvd_code)
),
cvd_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM cvd_all_dx
    WHERE rn = 1
),

--Dementia
dementia_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id = 4182210
),
dementia_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM dementia_code)
),
dementia_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM dementia_all_dx
    WHERE rn = 1
),

--Chronic pulmonary disease
copd_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id = 4063381
),
copd_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM copd_code)
),
copd_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM copd_all_dx
    WHERE rn = 1
),

--Rheumatologic disease
rheumato_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id IN (257628, 134442, 80800, 80809, 256197, 255348)
),
rheumato_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM rheumato_code)
),
rheumato_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM rheumato_all_dx
    WHERE rn = 1
),

--Peptic ulcer disease
pu_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id = 4247120
),
pu_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM pu_code)
),
pu_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM pu_all_dx
    WHERE rn = 1
),

--mild liver disease
mild_liver_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id IN (4064161, 4212540)
),
mild_liver_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM mild_liver_code)
),
mild_liver_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM mild_liver_all_dx
    WHERE rn = 1
),

--mild dm disease
mild_dm_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id = 201820
),
mild_dm_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM mild_dm_code)
),
mild_dm_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM mild_dm_all_dx
    WHERE rn = 1
),

--Complicated Diabetes
com_dm_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id IN (443767, 442793)
),
com_dm_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM com_dm_code)
),
com_dm_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM com_dm_all_dx
    WHERE rn = 1
),

--Hemiplegia or paraplegia
hemiplegia_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id IN (192606, 374022)
),
hemiplegia_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM hemiplegia_code)
),
hemiplegia_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM hemiplegia_all_dx
    WHERE rn = 1
),

--Renal disease
renal_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id IN (4030518)
),
renal_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM renal_code)
),
renal_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM renal_all_dx
    WHERE rn = 1
),

--Malignancy
ca_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id IN (443392)
),
ca_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM ca_code)
),
ca_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM ca_all_dx
    WHERE rn = 1
),

--Severe liver disease
severe_liver_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id IN (4245975, 4029488, 192680, 24966)
),
severe_liver_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM severe_liver_code)
),
severe_liver_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM severe_liver_all_dx
    WHERE rn = 1
),

--Metastatic solid tumor
met_tumor_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id IN (432851)
),
met_tumor_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM met_tumor_code)
),
met_tumor_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM met_tumor_all_dx
    WHERE rn = 1
),

--AIDS
aids_code AS (
    SELECT c.descendant_concept_id
    FROM vocab.concept_ancestor c
    WHERE c.ancestor_concept_id IN (439727)
),
aids_all_dx AS (
    SELECT  co.person_id,
            co.condition_concept_id,
            co.condition_start_date,
            co.condition_source_value,
            ROW_NUMBER() OVER(PARTITION BY co.person_id ORDER BY co.condition_start_date) as rn
    FROM cdm.condition_occurrence co
    WHERE condition_concept_id in (SELECT * FROM aids_code)
),
aids_first_dx AS (
    SELECT person_id,
            condition_concept_id,
            condition_start_date,
            condition_source_value
    FROM aids_all_dx
    WHERE rn = 1
)

SELECT 
    p.person_id,
    ----Comorbidities----
    -- dm.condition_start_date AS dm_start_date,
    ht.condition_start_date AS ht_start_date,
    dlp.condition_start_date AS dlp_start_date,
    af.condition_start_date AS af_start_date,
    ----Charlson Comorbidities----
    ami.condition_start_date AS ami_start_date,
    chf.condition_start_date AS chf_start_date,
    pvd.condition_start_date AS pvd_start_date,
    cvd.condition_start_date AS cvd_start_date,
    dementia.condition_start_date AS dementia_start_date,
    copd.condition_start_date AS copd_start_date,
    rheumato.condition_start_date AS rheumato_start_date,
    pu.condition_start_date AS pu_start_date,
    mild_liver.condition_start_date AS mild_liver_start_date,
    mild_dm.condition_start_date AS mild_dm_start_date,
    com_dm.condition_start_date AS com_dm_start_date,
    hemiplegia.condition_start_date AS hemiplegia_start_date,
    renal.condition_start_date AS renal_start_date,
    ca.condition_start_date AS ca_start_date,
    severe_liver.condition_start_date AS severe_liver_start_date,
    met_tumor.condition_start_date AS met_tumor_start_date,
    aids.condition_start_date AS aids_start_date
FROM pt p
----Comorbidities----
-- LEFT JOIN dm_first_dx dm ON p.person_id = dm.person_id
LEFT JOIN ht_first_dx ht ON p.person_id = ht.person_id
LEFT JOIN dlp_first_dx dlp ON p.person_id = dlp.person_id
LEFT JOIN af_first_dx af ON p.person_id = af.person_id
----Charlson Comorbidities----
LEFT JOIN ami_first_dx ami ON p.person_id = ami.person_id
LEFT JOIN chf_first_dx chf ON p.person_id = chf.person_id
LEFT JOIN pvd_first_dx pvd ON p.person_id = pvd.person_id
LEFT JOIN cvd_first_dx cvd ON p.person_id = cvd.person_id
LEFT JOIN dementia_first_dx dementia ON p.person_id = dementia.person_id
LEFT JOIN copd_first_dx copd ON p.person_id = copd.person_id
LEFT JOIN rheumato_first_dx rheumato ON p.person_id = rheumato.person_id
LEFT JOIN pu_first_dx pu ON p.person_id = pu.person_id
LEFT JOIN mild_liver_first_dx mild_liver ON p.person_id = mild_liver.person_id
LEFT JOIN mild_dm_first_dx mild_dm ON p.person_id = mild_dm.person_id
LEFT JOIN com_dm_first_dx com_dm ON p.person_id = com_dm.person_id
LEFT JOIN hemiplegia_first_dx hemiplegia ON p.person_id = hemiplegia.person_id
LEFT JOIN renal_first_dx renal ON p.person_id = renal.person_id
LEFT JOIN ca_first_dx ca ON p.person_id = ca.person_id
LEFT JOIN severe_liver_first_dx severe_liver ON p.person_id = severe_liver.person_id
LEFT JOIN met_tumor_first_dx met_tumor ON p.person_id = met_tumor.person_id
LEFT JOIN aids_first_dx aids ON p.person_id = aids.person_id


