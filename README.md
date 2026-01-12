# us_science_cuts

Analysis of the cuts of science grants in the US 2025

## Data

Data files are not included in this repository due to size. To obtain the required data:

### Required files

1. **NSF All Grants (2014-2026)**
   - Source: https://www.nsf.gov/awardsearch/download-awards
   - Download years 2014-2019 as TSV → `data/NSF_all_grants_2019-2014.tsv`
   - Download years 2020-2026 as TSV → `data/NSF_all_grants_2026-2020.tsv`

2. **Grant Witness - NSF Terminations**
   - Source: https://www.grantwitness.us/
   - Download NSF terminations → `data/grant_witness_nsf_terminations.csv`

### Optional files

- `data/grant_witness_nih_terminations.csv` - NIH terminations from Grant Witness
- `data/grant_witness_epa_terminations.csv` - EPA terminations from Grant Witness
- `data/cossa_NSF-Terminated-Awards.csv` - from https://cossa.org/nsf-releases-list-of-terminated-grants/

Run `code/download_data.R` for detailed download instructions.

## Analysis

Main analysis script: `code/read_data_tsv_csv.qmd`

### Output files

- `output/nsf_analysis.csv` - All NSF grants with termination status (one row per grant, cut grants first)
- `output/nsf_emails.csv` - Same data expanded to one row per email (for survey/analysis)
