#!bin/bash
qiime phylogeny align-to-tree-mafft-fasttree --i-sequences rep-seqs-dada2.qza --o-alignment aligned-rep-seqs.qza --o-masked-alignment masked-aligned-rep-seqs.qza --o-tree unrooted-tree.qza --o-rooted-tree rooted-tree.qza

qiime diversity alpha-rarefaction --i-table filtered-table.qza --i-phylogeny rooted-tree.qza --p-max-depth 26000 --m-metadata-file meta.txt --o-visualization alpha-rarefaction.qzv
