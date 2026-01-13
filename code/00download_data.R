# Explanation to download data files for US Science Cuts analysis

library(here)

# Create data directory if it doesn't exist
dir.create(here("data"), showWarnings = FALSE)

cat("=== Data Download Instructions ===\n\n")

cat("1. NSF All Grants (2014-2026)\n")
cat("   Source: https://www.nsf.gov/awardsearch/download-awards\n")
cat("   - Select years 2014-2019, download as TSV\n")
cat("   - Save as: data/NSF_all_grants_2019-2014.tsv\n")
cat("   - Select years 2020-2026, download as TSV\n")
cat("   - Save as: data/NSF_all_grants_2026-2020.tsv\n\n")

cat("2. Grant Witness - NSF Terminations\n")
cat("   Source: https://www.grantwitness.us/\n")
cat("   - Download NSF terminations CSV\n")
cat("   - Save as: data/grant_witness_nsf_terminations.csv\n\n")

cat("3. Grant Witness - NIH Terminations (optional)\n")
cat("   Source: https://www.grantwitness.us/\n")
cat("   - Download NIH terminations CSV\n")
cat("   - Save as: data/grant_witness_nih_terminations.csv\n\n")

cat("4. Grant Witness - EPA Terminations (optional)\n")
cat("   Source: https://www.grantwitness.us/\n")
cat("   - Download EPA terminations CSV\n")
cat("   - Save as: data/grant_witness_epa_terminations.csv\n\n")

cat("5. COSSA NSF Terminated Awards (optional)\n")
cat("   Source: https://cossa.org/nsf-releases-list-of-terminated-grants/\n")
cat("   - Download the CSV file\n")
cat("   - Save as: data/cossa_NSF-Terminated-Awards.csv\n\n")

cat("=== Required files for main analysis ===\n")
cat("- data/NSF_all_grants_2019-2014.tsv\n")
cat("- data/NSF_all_grants_2026-2020.tsv\n")
cat("- data/grant_witness_nsf_terminations.csv\n")
