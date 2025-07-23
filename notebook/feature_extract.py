
import json

'''
# Python code to generate SQL query
output
- patient_id with their corresponding first_date of diagnosis or drug

use create_combined_conditions_query or create_combined_drugs_query to generate a SQL code
arguments:
1. dictionary of diagnosis {'diag_name': condition_concept_id} or of drug {'drug_name': [list of codes]}
2. list of person_id in this cohort

(dictionary will be obtain from .json file in the same folder)

'''


def create_combined_conditions_query(person_id_list=None):

    with open('.\diagnosis_dict.json', 'r') as file:
        diagnosis_dict = json.load(file)
        file.close()

    select_query = """SELECT """

    for condition, code in diagnosis_dict.items():
        if len(code) == 1:
            condition_query = f"\n  MIN(CASE WHEN ca.ancestor_concept_id = {code[0]} THEN c.condition_start_date END) AS first_{condition}_date,"
        else:
            condition_query = f"\n  MIN(CASE WHEN ca.ancestor_concept_id IN {tuple(code)} THEN c.condition_start_date END) AS first_{condition}_date,"
        select_query += condition_query
    select_query += '\n p.person_id\n'

    all_codes = [code for code_list in diagnosis_dict.values() for code in code_list]

    if person_id_list:
        person_id_list = tuple(person_id_list)
    else:
        person_id_list = "INSERT_PERSON_ID"
    from_query = f"""FROM omop.person p
    LEFT JOIN omop.condition_occurrence c ON p.person_id = c.person_id
    LEFT JOIN vocab.concept_ancestor ca ON c.condition_concept_id = ca.descendant_concept_id
    WHERE ca.ancestor_concept_id IN {tuple(all_codes)}
    AND p.person_id in {person_id_list}
    GROUP BY p.person_id
    """

    query = select_query + from_query

    with open('extract_conditions.sql', 'w') as file:
        file.write(query)
        file.close()
    
    return query


if __name__ == '__main__':
    create_combined_conditions_query()