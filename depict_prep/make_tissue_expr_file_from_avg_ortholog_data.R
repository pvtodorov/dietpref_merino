############### SYNOPSIS ###################
# Make DEPICT tissue expression file from averaged gene expression file.
### INPUT DATA
# 1 Normalized (CPM or other normalization)
# 2 Averaged
# 3 Log-transformed averaged data (log(x+1))
# 4 Mapped to human 1-1 orthologs.
# 5 THIS SCRIPT : Z-score calculation 

### OUTPUT: 
# ....

### REMARKS:
# ....

### REFERENCE:

# ======================================================================= #
# =============================== SETUP ================================ #
# ======================================================================= #

# library(tidyverse)


# wd <- "/projects/timshel/DEPICT/src-expression_preprocessing/"
# setwd(wd)

# ======================================================================= #
# =============================== FUNCTIONS ================================ #
# ======================================================================= #

generate_depict_expression_data <- function(df.avg_expr, name.dataset) {
  ### INPUT
  # df.avg_expr           data frame. genes x annotations. with rownamesand columnnames.
  #                   as a 'standard' to ensure reproducibility, it is RECOMMENDED to *input a data.frame that has already been mapped to human genes*. 
  # name.dataset      prefix for output files
  ### OUTPUT
  # csv files written to working directory.
  
  # ======= Z score: gene-wise z-score (each gene mean=0, sd=1) ======
  ### to give cell-type specificity
  ### to remove the effect of ubiquitous expressed genes.
  df.zscores.gene_wise <- as.data.frame(t(scale(t(as.data.frame(df.avg_expr)), center = TRUE, scale = TRUE))) # returns a DATA FRAME with columns=annotations, rownames=genes.
  df.zscores.gene_wise.na <- df.zscores.gene_wise %>% filter_all(any_vars(is.na(.))) # we (sometimes) have NA values. Don't know why. It could be because some genes have zero-variance
  if (nrow(df.zscores.gene_wise.na) > 0) {print(
    sprintf("OBS: N=%s genes removed because they contained NA values after zscore calculation. ", nrow(df.zscores.gene_wise.na)))
  }
  df.zscores.gene_wise <- df.zscores.gene_wise[complete.cases(df.zscores.gene_wise), ] # *OBS* remove genes with NA values
  write_tsv(df.zscores.gene_wise %>% rownames_to_column(var="gene"), sprintf("%s.depict.z_score.tab", name.dataset))

  # ======= Z score: cell-type-wise z-score (each cell-type mean=0, sd=1) ======
  ### to get the genes highest expressed within a cell-type.
  df.zscores.gene_wise.celltype_wise <- as.data.frame(scale(df.zscores.gene_wise)) # returns a DATA FRAME with columns=annotations, rownames=genes.
  write_tsv(df.zscores.gene_wise.celltype_wise %>% rownames_to_column(var="gene"), sprintf("%s.depict.z_score_two_step.tab", name.dataset))
  
  return(NULL)
}

# ======================================================================= #
# ============================ LOAD DATA ============================ #
# ======================================================================= #


### Tabula muris
# name.dataset <- "tabula_muris.tissue_celltype"
# file.expr <- "/projects/timshel/sc-genetics/sc-genetics/data/expression/tabula_muris/tabula_muris.tissue_celltype.celltype_expr.avg_expr.hsapiens_orthologs.csv.gz"
# df.human <- read_csv(file.expr) %>% column_to_rownames(var="gene") %>% as.data.frame()


### Mousebrain (all cell-types)
# name.dataset <- "mousebrain.all"
# file.expr <- "/raid5/projects/timshel/sc-genetics/sc-genetics/data/expression/mousebrain/mousebrain.celltype_expr.avg_expr.hsapiens_orthologs.csv.gz"
# df.human <- read_csv(file.expr) %>% column_to_rownames(var="gene") %>% as.data.frame()

### Nestorowa 
# name.dataset <- "nestorowa2016.12_hspc_phenotypes"
# file.expr <- "/raid5/projects/timshel/DEPICT/data-expression/nestorowa2016.12_hspc_phenotypes.pre_normalized.avg_expr.log.hsapiens_orthologs.tab.gz"
# df.human <- read_tsv(file.expr) %>% column_to_rownames(var="gene") %>% as.data.frame()


### Nestorowa 
# name.dataset <- "baron2016.human_pancreas"
# file.expr <- "/data/pub-others/baron-cellsystems-2016/baron2016_human.avg_expr.ensembl.csv.gz"
# df.human <- read_csv(file.expr) %>% column_to_rownames(var="gene") %>% as.data.frame()


# ======================================================================= #
# =============================== RUN  ================================== #
# ======================================================================= #

### run function
# generate_depict_expression_data(df.avg_expr=df.human, name.dataset)
# MOUSEBRAIN --> "OBS: N=417 genes removed because they contained NA values after zscore calculation. "


