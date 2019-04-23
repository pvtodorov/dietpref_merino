# Diet preference FGWAS DEPICT
## Data preparation
Drop-seq and single-cell expression data of mouse arcuate nucleus and median eminence (GSE93374) was averaged using the Seurat AverageExpression function. Two different levels of clustering were used: a coarser clustering across all identified cell types shown and a finer-grained clustering limited to neuronal cell types as described in Campbell et al1. We then log-normalized the averaged counts using the default Seurat “logNormalize” method. This divides  each observed expression value by the sum for that gene, multiplies by a scaling factor (here the default, 10000), adds 1, and takes the natural log.

These files are too big for GitHub and would be found in 
```
depict_prep/projects/jonatan/tmp-holst-hsl/data/
```

They have been added to the `.gitignore`
```
aClust_meanExprLogN.RDS.gz                           nClustSub_meanExprLogN.log.hsapiens_orthologs.tab.gz
aClust_meanExprLogN.log.hsapiens_orthologs.tab.gz    nClust_meanExprLogN.RDS.gz
nClustSub_meanExprLogN.RDS.gz                        nClust_meanExprLogN.log.hsapiens_orthologs.tab.gz
```

## DEPICT methods
DEPICT version 1, release 194 (https://github.com/perslab/depict/) was used to prioritize hypothalamus cell clusters on the basis of fGWAS summary statistics for carbohydrate, protein, fat, and multi-trait diet preference (GWAS association P value cutoff  <10-5).
Drop-seq and single-cell expression data of mouse arcuate nucleus and median eminence (GSE93374) was averaged using the Seurat AverageExpression function. Two different levels of clustering were used: a coarser clustering across all identified cell types shown and a finer-grained clustering limited to neuronal cell types as described in Campbell et al1. We then log-normalized the averaged counts using the default Seurat “logNormalize” method. This divides  each observed expression value by the sum for that gene, multiplies by a scaling factor (here the default, 10000), adds 1, and takes the natural log.
Genes were mapped from mouse gene symbols to mouse Ensembl gene identifiers (using Ensembl version 83) and to the human Ensembl gene identifiers (using Ensembl version 82). Mouse gene identifiers mapping to several mouse Ensembl identifiers were discarded and the human gene with the highest degree of mouse homology was retained in instances where a mouse gene mapped to several human genes. Expression levels of mouse genes mapped to the same human gene were averaged. A two-step z-score procedure was applied such that the expression levels for each gene were transformed to standard normal distributions and the expression levels for each cell cluster were transformed to standard normal distributions. The resulting matrices were used to run DEPICT as previously described in Campbell et al<sup>1</sup>.
This step is is performed using the script
```
depict_prep/depict_prep.R
```

The resulting matrices were used to run DEPICT as previously described in Campbell et al<sup>1</sup>. This is performed by the scripts
```
src/call_run_depict_from_template_cfg_latest.sh

src/call_run_depict_from_template_cfg_BMI_locke_campbell_latest.sh
```

**References:**

1. Campbell, John N., Evan Z. Macosko, Henning Fenselau, Tune H. Pers, Anna Lyubetskaya, Danielle Tenen, Melissa Goldman, et al. “A Molecular Census of Arcuate Hypothalamus and Median Eminence Cell Types.” Nature Neuroscience 20, no. 3 (March 2017): 484–96. https://doi.org/10.1038/nn.4495.
