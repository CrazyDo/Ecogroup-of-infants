# The development of covarying gut microbiota network in preterm infants during early life up-to 5 years and its association with host early childhood growth

****
### How to use the function of eco?
```
source("eco.R")
```
##### Prepare the input data (raw counts), the row is sample, the column is taxa, the variable for timepoints must be 'tp'
```
res <- eco(data , f_taxa_col, l_taxa_col, method = "RA")
```
##### f_taxa_col: number of the most left column of the taxa matrix; l_taxa_col: number of the most right column of the taxa matrix
```
res$eco.taxa   # the ecotaxa
```

****
### How to reference?       
If you have used this script in your research, please use the following link for references to our script: https://github.com/CrazyDo/Ecogroup-of-infants
