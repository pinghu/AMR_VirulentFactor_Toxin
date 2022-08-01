1. first run "pitzer_cat_gzip.pl"
2. run "pitzer_clean_human75.pl"
3. run "pitzer_metaphlan3_humann3.pl"
4. run "count.job"
5. run "AfterJobProcess"
   if not run "AfterJobProcess":, do the first few steps in "AfterJobProcess",

   cd /fs/scratch/PYS0226/ar2767/GSS2681/biobakery
   mkdir /fs/scratch/PYS0226/ar2767/GSS2681/metaphlan3
   mkdir /fs/scratch/PYS0226/ar2767/GSS2681/humann3

   cp *.profile /fs/scratch/PYS0226/ar2767/GSS2681/metaphlan3/
   cp *humann3/*.tsv /fs/scratch/PYS0226/ar2767/GSS2681/humann3/
