# US Science Cuts 

Analysis of the cuts of science grants in the US 2025

## Folder structure 

After cloning the repository, add the following folders in the root directory:  

- code: contains all scripts, 01-03 for reading in and preparing nsf and nih data. 
- data_raw: Json files, or .zip files downloaded in bulk
- data: data in a format where they can be loaded into R/Python. Grant witness data is directly saved here. 
- data_analysis: data with selected columns relevant for statistical analysis, or for sending emails to PIs of NSF projects.
   - files are saved as .csv and .parquet. Parquet is a format readable for both Python and R without losing column formatting:

      ```python
      # Python
      import pandas as pd
      df = pd.read_parquet("file.parquet")
      ```

      ```r
      # R
      df <- arrow::read_parquet("file.parquet")
      ```
- add an additional folder for figures before you create any

## R Dependencies

Required R packages:

- tidyverse
- here
- arrow (for parquet format)
- lubridate (for NIH script date parsing)

## Scripts

Execute code in the order of numbered scripts in the code/ folder. 

01-03 are for downloading and reading/preparing NSF and NIH data. 

These scripts are only drafts, not working and not finished: 
- 04fetch_doge_grants.sh. Purpose: get the DOGE API running to see if there is more data on cut grants there, not yet included in the sources below. 
- 05read_hhs_pdf_data.R: maybe not required. Most HHS data is about NIH. But this includes some other smaller agencies. Check if these are included in the NIH dataset from grant witness. 

## Data

Data files are not included in this repository due to size. 

To obtain the required data for analysis: use the nextcloud link with the password given in the google with project notes
Link: https://nextcloud.csh.ac.at/index.php/s/AxQkmJmr6yJYGEA

To obtain the raw data:

### Required raw data files

1. **NSF All Grants (2014-2026)**
   - Source: https://www.nsf.gov/awardsearch/download-awards
   - Download all data as jsons into data_raw/NSF_all_grants/
   - Merge JSONS into `data/NSF_all_grants_2019-2014.tsv` using the script 01NSF_raw_data_json_to_tsv.sh. 

2. **Grant Witness - Termination Data for NSF, NIH and EPA**
   - Source: https://www.grantwitness.us/
   - Download NSF, NIH and EPA data, add grant_witness_ at the start of each file and move into a data/ folder. 
      - `data/grant_witness_nsf_terminations.csv`
      - `data/grant_witness_nih_terminations.csv`
      - `data/grant_witness_epa_terminations.csv` (terminated grants only; data on all EPA grants would need to be sourced separately - potential future work)

3. **NIH All Grants (2014-2025)**

   - Source: https://reporter.nih.gov/ and https://reporter.nih.gov/exporter
   - Download is performed by the script 03read_data_nih.qmd on first run.

### Optional files (used to check data in the scripts)

- `data/cossa_NSF-Terminated-Awards.csv` - from https://cossa.org/nsf-releases-list-of-terminated-grants/
- `data_raw/HHS_Grants_Terminated.pdf`: official list of terminated HHS awards https://taggs.hhs.gov/Content/Data/HHS_Grants_Terminated.pdf
   - grant witness data includes this as one of its sources

## NSF Data

All NSF grants 2014-2026, joined with Grant Witness termination data.

TIP: Check the award pages on NSF website to understand what the column names describe. For example:
https://www.nsf.gov/awardsearch/showAward?AWD_ID=2425253

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

- `data_analysis/nsf_analysis.csv` - CSV format for broad compatibility
- `data_analysis/nsf_analysis.parquet` - Parquet format (Python and R compatible)
- `data_analysis/nsf_emails.csv` - Same data expanded to one row per PI email

## NIH Data

TIP: Check the project pages on NIH website to understand what the column names describe. For example: 
https://reporter.nih.gov/project-details/10129786

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
- `data_analysis/nih_analysis.parquet` - Parquet format (Python and R compatible)

### Intermediate Cache Files

The NIH script creates cache files in `data/` to avoid reprocessing:

- `data/nih_exporter_usa_2014_2024.rds` - ExPORTER bulk download data (2014-2024) with abstracts
- `data/nih_exporter_usa_2014_2025.rds` - Combined 2014-2025 data (includes manual 2025 download)

Delete these files to force reprocessing from raw data.

### Known Limitations

- **study_section column**: For FY 2025 data, only `study_section_name` (the full name) is available. The `study_section` code is NA for 2025 grants because the manual NIH Reporter download doesn't include study section codes. FY 2014-2024 data has both columns populated.
