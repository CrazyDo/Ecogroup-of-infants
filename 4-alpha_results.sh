#!bin/bash
qiime diversity core-metrics-phylogenetic --i-phylogeny rooted-tree.qza --i-table filtered-table.qza --p-sampling-depth 2800 --m-metadata-file meta.txt --output-dir core-results
