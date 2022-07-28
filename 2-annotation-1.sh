#!bin/bash
cd demux/
for file in *.qza;
do
qiime dada2 denoise-paired --i-demultiplexed-seqs $file --p-trim-left-f 28 --p-trim-left-r 28 --p-trunc-len-f 295 --p-trunc-len-r 255 --p-n-threads 30 --o-representative-sequences ../DADA2/rep-seqs-dada2_$file --o-table ../DADA2/table-dada2_$file --o-denoising-stats ../DADA2/stats-dada2_$file
done
cd ../
qiime feature-table merge --i-tables DADA2/table-*.qza --o-merged-table table-dada2.qza
qiime feature-table merge-seqs --i-data DADA2/rep-seqs*.qza --o-merged-data rep-seqs-dada2.qza


qiime feature-table summarize --i-table table-dada2.qza --o-visualization table-dada2.qzv
qiime feature-table tabulate-seqs --i-data rep-seqs-dada2.qza --o-visualization rep-seqs.qzv

