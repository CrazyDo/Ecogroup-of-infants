#!bin/bash
cd list 
for file in *;
do
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path $file --output-path ../demux/demux_$file.qza --input-format PairedEndFastqManifestPhred33V2

done
#qiime demux summarize --i-data demux.qza --o-visualization demux_dada2.qzv
