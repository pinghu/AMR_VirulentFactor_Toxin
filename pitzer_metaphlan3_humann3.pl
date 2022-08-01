#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### https://www.osc.edu/resources/available_software/software_list/python
#https://www.osc.edu/resources/getting_started/howto/howto_locally_installing_software
##########################################################################
use strict;
my $usage="$0  [file] first line is title\n"; 
die $usage unless @ARGV ==1;
my ($file) = @ARGV;
my $dir="/fs/scratch/PYS0226/pg123/GSS2667HomeMicrobiome/merge2/";
my $rstD="/fs/scratch/PYS0226/pg123/GSS2667HomeMicrobiome/biobakery/";


open (A, "<$file")||die "could not open $file\n";
my $count=0;
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    
    $count++;
    open (B, ">OSC.kraken.$count")||die "could not open OSC.kraken.$count\n";
    print B "#!/bin/bash\n";
    print B "#SBATCH --time=12:00:00\n";
    print B "#SBATCH --nodes=1 --ntasks-per-node=40\n";
    print B "#SBATCH --account=PYS0226\n";
    print B "\n";
    print B "source /users/PYS0226/pg123/.bashrc\n";
    print B "conda activate biobakery3\n";
    print B "cd $dir\n";

    #print B "module load bowtie2\n";


    print B "metaphlan  $dir/$a.fastq  --bowtie2db /fs/project/PYS0226/pg123/metaphlan3Database/  --bt2_ps very-sensitive  -t rel_ab_w_read_stats --bowtie2out $rstD/$a.bowtie2.bz2 --input_type fastq --nproc 40 -o $rstD/$a.metaphlan3.profile --add_viruses   1>$rstD/$a.metaphlan.out 2>$rstD/$a.err\n";

    print B "humann -i $dir/$a.fastq -o $rstD/$a.humann3 --memory-use maximum --taxonomic-profile $rstD/$a.metaphlan3.profile --threads 40 1>$rstD.$a.humann.out 2>$rstD/$a.humann.err\n";

    print B "conda deactivate\n";
    close B;
    print "sbatch OSC.kraken.$count\n";
}
close A;
