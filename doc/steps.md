# Steps

This repository intend to create a **Type 2 Diabetes Mellitus** patients from Siriraj Hospital Data. The data was structured in OMOP CDM V5.4.

Here are the steps for building this cohort.

### 1. Inclusion


```
The inclusion critieria of previously built cohort are as follows
1. Patients with the ICD10 diagnosis of "E11*"
2. Patients with lab investigations (any of the follow)
   1. FBS >= 126 for >= 2 occasions
   2. FBS >= 126 for >= 1 occasion and HbA1c >= 6.5 for >= 1 occasion
   3. HbA1c >= 6.5 for >= 2 occasions
   4. OGTT >= 200 for >= 1 occasion
3. Patients receiving drug for DM treatment
```
<details>
  <summary>Generic Name drugs list</summary>
  
   'Acarbose', 'Acarbose', 'Exenatide', 'Glibenclamide (Glyburide)',
   'Glibenclamide (Glyburide)', 'Glibenclamide (Glyburide)',
   'Gliclazide', 'Gliclazide', 'Gliclazide', 'Gliclazide',
   'Gliclazide', 'Gliclazide', 'Gliclazide', 'Gliclazide',
   'Glimepiride', 'Glimepiride', 'Glimepiride', 'Glimepiride',
   'Glimepiride', 'Glimepiride', 'Glimepiride', 'Glimepiride',
   'Glimepiride', 'Glipizide', 'Glipizide', 'Glipizide', 'Gliquidone',
   'Insulin aspart', 'Insulin aspart, Insulin aspart protamine',
   'Insulin aspart, Insulin aspart protamine', 'Insulin detemir',
   'Insulin glargine', 'Insulin glargine', 'Insulin glargine',
   'Insulin glargine', 'Insulin glulisine', 'Insulin glulisine',
   'Insulin isophane', 'Insulin isophane', 'Insulin isophane',
   'Insulin isophane', 'Insulin isophane', 'Insulin isophane',
   'Insulin isophane', 'Insulin isophane', 'Insulin lispro',
   'Insulin lispro, Insulin lispro protamine',
   'Insulin lispro, Insulin lispro protamine', 'Insulin regular',
   'Insulin regular', 'Insulin regular', 'Insulin regular',
   'Insulin regular', 'Insulin regular', 'Insulin regular',
   'Insulin regular and Insulin isophane',
   'Insulin regular and Insulin isophane',
   'Insulin regular and Insulin isophane',
   'Insulin regular and Insulin isophane',
   'Insulin regular and Insulin isophane',
   'Insulin regular and Insulin isophane',
   'Insulin regular and Insulin isophane',
   'Insulin regular and Insulin isophane',
   'Insulin regular and Insulin isophane', 'Metformin', 'Metformin',
   'Metformin', 'Metformin', 'Metformin', 'Metformin', 'Metformin',
   'Metformin', 'Metformin', 'Metformin',
   'Metformin and Glibenclamide', 'Metformin and Glibenclamide',
   'Metformin and Pioglitazone', 'Metformin and Rosiglitazone',
   'Metformin and Sitagliptin', 'Metformin and Sitagliptin',
   'Metformin and Sitagliptin', 'Metformin and Sitagliptin',
   'Pioglitazone', 'Pioglitazone', 'Pioglitazone', 'Pioglitazone',
   'Pioglitazone', 'Repaglinide', 'Repaglinide', 'Repaglinide',
   'Rosiglitazone', 'Rosiglitazone', 'Saxagliptin', 'Sitagliptin',
   'Sitagliptin', 'Vildagliptin', 'Vildagliptin', 'Voglibose',
   'Voglibose', 'Liraglutide', 'Liraglutide',
   'Metformin and Vildagliptin', 'Metformin and Vildagliptin',
   'Linagliptin', 'Metformin and Saxagliptin',
   'Metformin and Saxagliptin', 'Metformin and Glimepiride',
   'Metformin and Linagliptin', 'Metformin and Linagliptin',
   'Dapagliflozin', 'Alogliptin', 'Alogliptin and Pioglitazone',
   'Alogliptin and Pioglitazone', 'Empagliflozin', 'Empagliflozin',
   'Insulin degludec', 'Empagliflozin and Metformin',
   'Empagliflozin and Metformin', 'Canagliflozin', 'Canagliflozin',
   'Luseogliflozin', 'Luseogliflozin', 'Dapagliflozin and Metformin',
   'Dapagliflozin and Metformin', 'Gemigliptin',
   'Empagliflozin and Linagliptin', 'Empagliflozin and Linagliptin',
   'Insulin degludec, Insulin aspart', 'Dulaglutide', 'Dulaglutide',
   'Insulin Degludec and Liraglutide',
   'Insulin glargine and Lixisenatide',
   'Insulin glargine and Lixisenatide', 'Trelagliptin Succinate',
   'Semaglutide', 'Semaglutide', 'Semaglutide', 'Semaglutide',
   'Semaglutide', 'Semaglutide', 'Teneligliptin', 'Evogliptin',
   'Gemigliptin and Metformin'
  
</details>

<br />

Previously built cohort was build with the study period of *June 2013 - Sep 2023.* Although the OMOP data have more data than this period. For the comparison purpose, we will limit the data to this period.
