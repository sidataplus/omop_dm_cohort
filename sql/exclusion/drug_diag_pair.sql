WITH all_union_cond AS (
    SELECT  hf.person_id,
            MIN(hf.condition_start_date) as first_hf_date,
            NULL as first_ckd_date,
            NULL as first_obs_date
    FROM omop.condition_occurrence hf
    WHERE EXISTS (
        SELECT 1
        FROM omop.concept_ancestor c
        WHERE c.ancestor_concept_id = 316139 -- heart failure
        AND hf.condition_concept_id = c.descendant_concept_id
    )
    GROUP BY hf.person_id
    UNION ALL
    SELECT  ckd.person_id,
            NULL as first_hf_date,
            MIN(ckd.condition_start_date) as first_ckd_date,
            NULL as first_obs_date
    FROM omop.condition_occurrence ckd
    WHERE EXISTS (
        SELECT 1
        FROM omop.concept_ancestor c
        WHERE c.ancestor_concept_id = 46271022 -- ckd code
        AND ckd.condition_concept_id = c.descendant_concept_id
    )
    GROUP BY ckd.person_id
    UNION ALL
    SELECT  obs.person_id,
            NULL as first_hf_date,
            NULL as first_ckd_date,
            MIN(obs.condition_start_date) as first_obs_date
    FROM omop.condition_occurrence obs
    WHERE EXISTS (
        SELECT 1
        FROM omop.concept_ancestor c
        WHERE c.ancestor_concept_id = 433736 -- obesity code
        AND obs.condition_concept_id = c.descendant_concept_id
    )
    GROUP BY obs.person_id
),
baseline AS (
    SELECT  person_id,
            MIN(first_hf_date) as first_hf_date,
            MIN(first_ckd_date) as first_ckd_date,
            MIN(first_obs_date) as first_obs_date
    FROM all_union_cond
    GROUP BY person_id
),
all_drug_start AS (
    SELECT ud.person_id,
            MIN(ud.sglt2_start_date) as sglt2_start_date,
            MIN(ud.glp_start_date) as glp_start_date
    FROM (
        SELECT person_id, sglt2_start_date, NULL as glp_start_date
        FROM (
            SELECT d.person_id,
                    d.drug_exposure_start_date as sglt2_start_date
            FROM omop.drug_exposure d
            WHERE d.drug_source_value IN ('FORT10', 'JART10', 'JART25', 'INVT100', 'INVT300', 'LUST5', 'LUST25')
        ) sglt2_date
        UNION ALL
        SELECT person_id, NULL as sglt2_start_date, glp_start_date
        FROM (
            SELECT d.person_id,
                    d.drug_exposure_start_date as glp_start_date
            FROM omop.drug_exposure d
            WHERE d.drug_source_value IN ('BYEI10', 'SAXI', 'VICIP18', 'TRUI15', 'TRUI75', 'OZEI1', 'OZEI05', 'OZEI025', 'RYBT3', 'RYBT7', 'RYBT14')
        ) glp_date
    ) ud
    GROUP BY ud.person_id
)
SELECT b.person_id,
    b.first_hf_date,
    b.first_ckd_date,
    b.first_obs_date,
    d.glp_start_date,
    d.sglt2_start_date
FROM baseline b
LEFT JOIN all_drug_start d ON d.person_id = b.person_id
WHERE b.person_id IN (insert_list_person_id)
