library(tabulizer)
library(dplyr)

# 1. Define the path to your PDF file
# IMPORTANT: Replace "path/to/your/awards_report.pdf" with the actual path
pdf_file <- "path/to/your/awards_report.pdf" 

# 2. Extract tables from the PDF
# 'pages = 1:51' tells it to process all 51 pages (based on the footer of the image)
# 'output = "data.frame"' attempts to output the result directly as data frames
# 'method = "stream"' is usually best for tables with clear white space and borders

print("Attempting to extract tables...")
# suppressWarnings is used because tabulizer often throws minor conversion warnings
all_tables <- suppressWarnings(
  extract_tables(
    file = pdf_file,
    pages = 1:51,
    method = "stream",
    output = "data.frame"
  )
)

# Check how many tables were extracted
num_extracted <- length(all_tables)
print(paste(num_extracted, "tables (one per page) extracted."))


# 3. Clean and Combine Data

# The header row often gets extracted separately or poorly on the first page.
# We will use the columns from the first extracted table, assuming it captured the headers.

# Get the headers from the first table
header_names <- as.character(all_tables[[1]][1, ]) 

# Check if the header names look reasonable
if (length(header_names) < 10) {
  stop("Header extraction failed. Review the first page extraction manually.")
}

# Combine all extracted data frames, skipping the (often messy) header rows 
# that repeat on subsequent pages.

final_data <- bind_rows(lapply(all_tables, function(df) {
  # Skip the first row (the header) and assign new header names
  df_clean <- df[-1, ]
  
  # Ensure the column count matches before assigning names
  if (ncol(df_clean) == length(header_names)) {
    names(df_clean) <- header_names
    return(df_clean)
  } else {
    # If the column count doesn't match (common if a page is blank or malformed),
    # we return NULL and will filter it out.
    warning("Skipping a page due to column mismatch.")
    return(NULL)
  }
}))

# 4. Final Data Cleaning (if needed)

# Remove any empty rows that might have been introduced during combination
final_data <- final_data %>%
  filter(if_any(everything(), ~ . != ""))

print(paste("Successfully processed", nrow(final_data), "award records."))


# 5. Output the result to a CSV file

output_file <- "awards_report_output.csv"
write.csv(final_data, output_file, row.names = FALSE, na = "")

print(paste("Data saved to:", output_file))