setwd("~/Projects/depict_prep/")

dir.sc_genetics_lib <- "projects/timshel/sc-genetics/sc-genetics/src/lib/"
source(sprintf("%s/load_functions.R", dir.sc_genetics_lib)) # load sc-genetics library
source(sprintf("make_tissue_expr_file_from_avg_ortholog_data.R")) # load generate_depict_expression_data

infolder <- "projects/jonatan/tmp-holst-hsl/data/"
file_names <- c("aClust_meanExprLogN", "nClust_meanExprLogN", "nClustSub_meanExprLogN")

for (fn in file_names) {
  file_path <- paste0(infolder, fn, ".RDS.gz")
  df.avg.log <- readRDS(file_path)
  avg.human <- mouse_to_human_ortholog_gene_expression_mapping(df.avg.log, type_mouse_gene_ids="mgi")
  human.outfile <- paste0(infolder, fn, ".log.hsapiens_orthologs.tab.gz")
  write_tsv(avg.human %>% rownames_to_column(var="gene"), human.outfile)
  depict.outfile <- paste0("depict_inputs/","campbell.DEPICT_INPUT.", fn, ".log.hsapiens_orthologs.csv.gz")
  generate_depict_expression_data(df.avg_expr=avg.human, depict.outfile)
}
