#! /usr/bin/perl -w
###########################################################################
##### Author: Ping HU
##### https://www.osc.edu/resources/available_software/software_list/python
##https://www.osc.edu/resources/getting_started/howto/howto_locally_installing_software
###########################################################################
use strict;
my $usage="$0  [file] first line is title\n";
die $usage unless @ARGV ==1;
my ($file) = @ARGV;
my $dir="/fs/scratch/PYS0226/pg123/GSS2667HomeMicrobiome/merge2/";
my $rstD="/fs/scratch/PYS0226/pg123/GSS2667HomeMicrobiome/deeparg/";

open (A, "<$file")||die "could not open $file\n";
my $count=0;
while (my $a=<A>){
   chomp $a;
   for($a){s/\r//gi;}
   $count++;
   open (B, ">OSC.deeparg.$count")||die "could not open OSC.deeparg.$count\n";
   print B "#!/bin/bash\n";
   print B "#SBATCH --time=12:00:00\n";
   print B "#SBATCH --nodes=1 --ntasks-per-node=24\n";
   print B "#SBATCH --account=PYS0226\n";
   print B "\n";
   print B "source /users/PYS0226/pg123/.bashrc\n";
   print B "conda activate deeparg_env\n";
   print B "cd $dir\n";
   #print B "module load bowtie2\n";
   #print B "module load samtools\n";
   #print B "module load trimmomatic \n";
   print B "deeparg short_reads_pipeline --forward_pe_file $dir/$a.fastq --reverse_pe_file $dir/$a.fastq --output_file $rstD/$a.deeparg -d /fs/project/PYS0226/pg123/deepargDatabase/ --bowtie_16s_identity 100 1>$rstD/$a.deeparg.out 2>$rstD/$a.deeparg.err\n";
   print B "conda deactivate\n";
   close B;
   print "sbatch OSC.deeparg.$count\n";
}
close A;

