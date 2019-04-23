#!/usr/bin/env bash


module unload anaconda
module load anaconda/2-4.4.0

### CONSTANTS
SCRIPT_PATH=/projects/petar/dietpref_merino/src/run_depict_from_template_cfg.py
CFG_TEMPLATE=/projects/petar/dietpref_merino/cfg/TEMPLATE_locke_latest.cfg

###################################### STANDARD DEPICT TISSUE ######################################

# EXPRESSION_FILE=/scratch/tmp-depict-1.0.174/data/tissue_expression/GPL570EnsemblGeneExpressionPerTissue_DEPICT20130820_z_withmeshheader.txt

EXPRESSION_FOLDER=/projects/petar/dietpref_merino/data/campbell_expression_latest/
declare -a EXPRESSION_FILES=(
aClust
nClust
nClustSub
)

GWAS_FOLDER=/projects/timshel/sc-genetics/sc-genetics/data/gwas_sumstats/
declare -a GWAS_FILES=(
body_BMI_Locke2015_All.gwassumstats.rolypoly_fmt.tab.gz
)

for i in "${EXPRESSION_FILES[@]}"
do
for j in "${GWAS_FILES[@]}"
do
gs1=""
es1="campbell.DEPICT_INPUT."
es2="_meanExprLogN.log.hsapiens_orthologs.csv.gz.depict.z_score_two_step.tab"
python ${SCRIPT_PATH} --cfg_template_file $CFG_TEMPLATE \
--gwas_summary_statistics_file $GWAS_FOLDER$j$gs1 \
--label_for_output_files $j"-BMI_locke-"$i \
--tissue_expression_file $EXPRESSION_FOLDER$es1$i$es2 &

done
done

### BMI-locke
# python ${SCRIPT_PATH} --cfg_template_file $CFG_TEMPLATE \
# --gwas_summary_statistics_file /projects/timshel/sc-genetics/sc-genetics/data/gwas_sumstats/body_BMI_Locke2015_All.gwassumstats.rolypoly_fmt.tab.gz \
# --label_for_output_files BMI-locke_1e-5_depict_campbell \
# --tissue_expression_file $EXPRESSION_FILE &

wait
