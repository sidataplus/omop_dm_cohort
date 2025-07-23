SELECT 
  MIN(CASE WHEN ca.ancestor_concept_id = 320128 THEN c.condition_start_date END) AS first_ht_date,
  MIN(CASE WHEN ca.ancestor_concept_id = 432867 THEN c.condition_start_date END) AS first_dlp_date,
  MIN(CASE WHEN ca.ancestor_concept_id = 321052 THEN c.condition_start_date END) AS first_pvd_date,
  MIN(CASE WHEN ca.ancestor_concept_id IN (381591, 434056) THEN c.condition_start_date END) AS first_cvd_date,
  MIN(CASE WHEN ca.ancestor_concept_id = 4030518 THEN c.condition_start_date END) AS first_ckd_date,
  MIN(CASE WHEN ca.ancestor_concept_id = 80502 THEN c.condition_start_date END) AS first_osteoporosis_date,
  MIN(CASE WHEN ca.ancestor_concept_id = 75053 THEN c.condition_start_date END) AS first_fracture_date,
 p.person_id
FROM omop.person p
    LEFT JOIN omop.condition_occurrence c ON p.person_id = c.person_id
    LEFT JOIN vocab.concept_ancestor ca ON c.condition_concept_id = ca.descendant_concept_id
    WHERE ca.ancestor_concept_id IN (320128, 432867, 321052, 381591, 434056, 4030518, 80502, 75053)
    AND p.person_id in INSERT_PERSON_ID
    GROUP BY p.person_id
    