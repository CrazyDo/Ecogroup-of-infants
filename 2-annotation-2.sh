#!bin/bash

qiime feature-table filter-features --i-table table-dada2.qza --p-min-samples 2 --o-filtered-table filtered-table.qza

qiime feature-table summarize --i-table filtered-table.qza --o-visualization filtered-table.qzv

qiime feature-classifier classify-sklearn --i-classifier classifier.qza --i-reads rep-seqs-dada2.qza --o-classification taxonomy.qza

qiime taxa barplot  --i-table filtered-table.qza  --i-taxonomy taxonomy.qza  --o-visualization taxa-dada2-plot.qzv

qiime metadata tabulate --m-input-file taxonomy.qza --o-visualization taxonomy.qzv

echo "100% is done"
