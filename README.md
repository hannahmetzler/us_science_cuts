# us_science_cuts

Analysis of the cuts of science grants in the US 2025

## Folder structure 

After cloning the repository, add the following folders in the root directory:  

- data_raw
- data
- data_analysis


## Data

Data files are not included in this repository due to size. To obtain the required data:

### Required files

1. **NSF All Grants (2014-2026)**
   - Source: https://www.nsf.gov/awardsearch/download-awards
   - Download all data as jsons into data_raw/NSF_all_grants/
   - Merge JSONS into `data/NSF_all_grants_2019-2014.tsv` using the script 01NSF_raw_data_json_to_tsv.sh. 

2. **Grant Witness - Termination Data for NSF, NIH and EPA**
   - Source: https://www.grantwitness.us/
   - Download NSF, NIH and EPA data, add grant_witness_ at the start of each file and move into a data/ folder. 
      - `data/grant_witness_nsf_terminations.csv`
      - `data/grant_witness_nih_terminations.csv` 
      - `data/grant_witness_epa_terminations.csv`

### Optional files (used to check data in the scripts)

- `data/cossa_NSF-Terminated-Awards.csv` - from https://cossa.org/nsf-releases-list-of-terminated-grants/
- HHS'_Grants_Terminated.pdf: official list of terminated HHS awards https://taggs.hhs.gov/Content/Data/HHS_Grants_Terminated.pdf


## Preparing datasets: 

Execute code in the order of numbered scripts in the code/ folder. 

- 04fetch_doge_grants.sh: Not finished, not working
- 05read_hhs_pdf_data.R: Not finished, not working, maybe not required

### Output files: data_analysis

- `data_analysis/nsf_analysis.csv` - All NSF grants with termination status (one row per grant, cut grants first)
- `data_analysis/nsf_one_line_per_email.csv` - Same data expanded to one row per email (for survey/analysis)

## NSF Data

All NSF grants 2014-2026, joined with Grant Witness termination data.

### Dataset Statistics

| Metric         | Count   |
|----------------|---------|
| Total rows     | ~350,000 |
| Total columns  | 26      |
| Cut grants     | ~1,600   |
| Non-cut grants | ~348,000 |
| Years          | 2014-2026 |

### Column Structure (26 columns)

**From NSF (12 columns)** - authoritative grant data:

- IDs: grant_id, agcy_id
- PI: pi_names, pi_emails
- Project: title, abstract
- Dates: start_date, end_date
- Budget: total_budget, amount_awarded
- Organization: org_name, org_state

**From Grant Witness (13 columns)** - termination-specific:

- Status: terminated, suspended, termination_date
- Reinstatement: reinstated, reinstatement_date
- Agency info: award_type, division, directorate, nsf_program_name
- Spending: usasp_outlaid, estimated_remaining, post_termination_deobligation
- URLs: nsf_url, usaspending_url

**Derived (1 column):**

- was_cut: TRUE/FALSE flag indicating if grant was terminated

**Note:** Cut grants have `was_cut == TRUE`. Use `was_cut` or `!is.na(terminated)` to filter.

### Output Files

- `data_analysis/nsf_analysis.csv` - All NSF grants with termination status
- `data_analysis/nsf_emails.csv` - Same data expanded to one row per PI email

## NIH Data

Only grants to US institutions (country code USA in NIH ExPORTER).

### Dataset Statistics

| Metric         | Count   |
|----------------|---------|
| Total rows     | ~230,000 |
| Total columns  | 38      |
| Cut grants     | ~5,800   |
| Non-cut grants | ~224,000 |
| Fiscal years   | 2014-2025 |

### Column Structure (38 columns)

**From ExPORTER (21 columns)** - authoritative grant data:

- IDs: application_id, core_project_num
- Agency (IC = Institute or Center, organizational units of the NIH): administering_ic, administering_ic_name, study_section, study_section_name
- PI: pi_names
- Organization: org_name, org_state, congressional_district, org_dept, organization_type
- Project: project_title, project_terms, public_health_relevance, nih_spending_categorization, project_abstract
- Dates: fiscal_year, project_start, project_end
- Budget: total_cost

**From Grant Witness (17 columns)** - termination-specific:

- Status: status, ever_frozen
- Dates: targeted_start_date, targeted_end_date, frozen_date, unfrozen_date, termination_date
- Reinstatement: reinstatement_indicator, reinstated_est_date
- Spending: total_estimated_outlays, total_estimated_remaining, last_payment_date, cancellation_source
- Analysis: flagged_words
- Political: us_rep
- URLs: usaspending_url, reporter_url

**Note:** Cut grants have non-NA `status`. Use `!is.na(status)` to filter.

### Output Files

- `data_analysis/nih_analysis.csv` - CSV format for broad compatibility
- `data_analysis/nih_analysis.rds` - RDS format preserving R data types
