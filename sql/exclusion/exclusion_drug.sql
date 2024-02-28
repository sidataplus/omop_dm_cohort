WITH sglt2 AS (
    SELECT DISTINCT d.person_id
    FROM cdm.drug_exposure d
    WHERE d.drug_source_value IN ('FORT10', 'JART10', 'JART25', 'INVT100', 'INVT300', 'LUST5', 'LUST25', 'ZEMT')
)

SELECT * FROM sglt2
