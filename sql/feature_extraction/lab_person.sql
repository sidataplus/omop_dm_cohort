SELECT m.person_id,
    m.measurement_date,

    --CBC
    AVG(CASE WHEN m._measurement_name = 'Hemoglobin' THEN TRY_CAST(m.value_source_value AS float) END) AS Hemoglobin,
    AVG(CASE WHEN m._measurement_name = 'Hematocrit' THEN TRY_CAST(m.value_source_value AS float) END) AS Hematocrit,
    AVG(CASE WHEN m._measurement_name = 'Wbc count' THEN TRY_CAST(m.value_source_value AS float) END) AS Wbc_count,
    AVG(CASE WHEN m._measurement_name = 'Platelet count' THEN TRY_CAST(m.value_source_value AS float) END) AS Platelet_count,
    AVG(CASE WHEN m._measurement_name = '% Neutrophils' THEN TRY_CAST(m.value_source_value AS float) END) AS Neutrophils,
    AVG(CASE WHEN m._measurement_name = '% Lymphocytes' THEN TRY_CAST(m.value_source_value AS float) END) AS Lymphocytes,

    --Chemistry
    AVG(CASE WHEN m._measurement_name = 'Creatinine' THEN TRY_CAST(m.value_source_value AS float) END) AS Creatinine,
    AVG(CASE WHEN m._measurement_name = 'BUN' THEN TRY_CAST(m.value_source_value AS float) END) AS BUN,
    AVG(CASE WHEN m._measurement_name = '**eGFR(CKD-EPI equation)' THEN TRY_CAST(m.value_source_value AS float) END) AS eGFR,
    AVG(CASE WHEN m._measurement_name = 'Sodium (Na+)' THEN TRY_CAST(m.value_source_value AS float) END) AS Sodium,
    AVG(CASE WHEN m._measurement_name = 'Potassium (K+)' THEN TRY_CAST(m.value_source_value AS float) END) AS Potassium,
    AVG(CASE WHEN m._measurement_name = 'Chloride (Cl-)' THEN TRY_CAST(m.value_source_value AS float) END) AS Chloride,
    AVG(CASE WHEN m._measurement_name = 'Bicarbonate (HCO3-)' THEN TRY_CAST(m.value_source_value AS float) END) AS Bicarbonate,

    --Glucose
    AVG(CASE WHEN m._measurement_name = 'Glucose (NaF)' THEN TRY_CAST(m.value_source_value AS float) END) AS Glucose,

    --Liver
    AVG(CASE WHEN m._measurement_name = 'AST (SGOT)' THEN TRY_CAST(m.value_source_value AS float) END) AS AST,
    AVG(CASE WHEN m._measurement_name = 'ALT (SGPT)' THEN TRY_CAST(m.value_source_value AS float) END) AS ALT,
    AVG(CASE WHEN m._measurement_name = 'Alkaline (ALP)' THEN TRY_CAST(m.value_source_value AS float) END) AS Alkaline,
    AVG(CASE WHEN m._measurement_name = 'Total Bilirubin' THEN TRY_CAST(m.value_source_value AS float) END) AS Bilirubin,
    AVG(CASE WHEN m._measurement_name = 'Albumin' THEN TRY_CAST(m.value_source_value AS float) END) AS Albumin,

    --Coagulogram
    AVG(CASE WHEN m._measurement_name = 'PT' THEN TRY_CAST(m.value_source_value AS float) END) AS PT,
    AVG(CASE WHEN m._measurement_name = 'INR' THEN TRY_CAST(m.value_source_value AS float) END) AS INR,
    AVG(CASE WHEN m._measurement_name = 'APTT' THEN TRY_CAST(m.value_source_value AS float) END) AS APTT,
    
    --Lipid
    AVG(CASE WHEN m._measurement_name = 'Triglyceride' THEN TRY_CAST(m.value_source_value AS float) END) AS Triglyceride,
    AVG(CASE WHEN m._measurement_name = 'Cholesterol' THEN TRY_CAST(m.value_source_value AS float) END) AS Cholesterol,
    AVG(CASE WHEN m._measurement_name = 'HDL-CHOL' THEN TRY_CAST(m.value_source_value AS float) END) AS HDL

FROM cdm.measurement m
WHERE m.person_id IN (INSERT_PERSON_ID_LIST)
GROUP BY m.person_id, m.measurement_date
