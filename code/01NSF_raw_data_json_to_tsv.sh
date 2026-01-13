#!/usr/bin/env bash

# Folder containing JSON files
JSON_DIR="../data_raw/NSF_all_grants/"   # adjust if needed
OUTPUT="NSF_all_grants_2019-2014.tsv"

# Remove old output file
rm -f "$OUTPUT"

# Header
echo -e "awd_id\tagcy_id\ttran_type\tawd_istr_txt\tawd_titl_txt\tcfda_num\torg_code\tpo_phone\tpo_email\tpo_sign_block_name\tawd_eff_date\tawd_exp_date\ttot_intn_awd_amt\tawd_amount\tawd_abstract_narration\tpi_names\tpi_emails\tinst_name\tinst_city\tinst_state\tperf_inst_name\tperf_city\tperf_state\tpgm_ele_names\tpgm_ref_names\tapp_fund_names\tfund_oblg_amt" > "$OUTPUT"

# Loop through all JSON files
for FILE in "$JSON_DIR"*.json; do
  echo "Processing $FILE ..."

  jq -r '
    .awd_abstract_narration |= (if .==null then "" else gsub("[\r\n]+";" ") end) |
    # PI info
    (if .pi then [.pi[]?.pi_full_name // ""] | join(", ") else "" end) as $pi_names |
    (if .pi then [.pi[]?.pi_email_addr // ""] | join(", ") else "" end) as $pi_emails |
    # Program elements
    (if .pgm_ele then [.pgm_ele[]?.pgm_ele_name // ""] | join(", ") else "" end) as $pgm_ele_names |
    (if .pgm_ref then [.pgm_ref[]?.pgm_ref_txt // ""] | join(", ") else "" end) as $pgm_ref_names |
    (if .app_fund then [.app_fund[]?.fund_name // ""] | join(", ") else "" end) as $app_fund_names |
    (if .oblg_fy then [.oblg_fy[]?.fund_oblg_amt // 0] | add else 0 end) as $fund_oblg_amt |
    [
      .awd_id // "",
      .agcy_id // "",
      .tran_type // "",
      .awd_istr_txt // "",
      .awd_titl_txt // "",
      .cfda_num // "",
      .org_code // "",
      .po_phone // "",
      .po_email // "",
      .po_sign_block_name // "",
      .awd_eff_date // "",
      .awd_exp_date // "",
      .tot_intn_awd_amt // 0,
      .awd_amount // 0,
      .awd_abstract_narration,
      $pi_names,
      $pi_emails,
      .inst.inst_name // "",
      .inst.inst_city_name // "",
      .inst.inst_state_name // "",
      .perf_inst.perf_inst_name // "",
      .perf_inst.perf_city_name // "",
      .perf_inst.perf_st_name // "",
      $pgm_ele_names,
      $pgm_ref_names,
      $app_fund_names,
      $fund_oblg_amt
    ] | @tsv
  ' "$FILE" >> "$OUTPUT"
done

echo "Done. Check $OUTPUT"
