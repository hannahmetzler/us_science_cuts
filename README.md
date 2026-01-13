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
