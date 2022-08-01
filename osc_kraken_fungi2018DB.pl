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
my $rstD="/fs/scratch/PYS0226/pg123/GSS2667HomeMicrobiome/kraken_fungi2019DB/";


open (A, "<$file")||die "could not open $file\n";
my $count=0;
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    
    $count++;
    open (B, ">OSC.MF.$count")||die "could not open OSC.BWA.$count\n";
    print B "#!/bin/bash\n";
    print B "#SBATCH --time=12:00:00\n";
    print B "#SBATCH --nodes=1 --ntasks=40\n";
    print B "#SBATCH --account=PYS0226\n";
    print B "\n";
    print B "source /users/PYS0226/pg123/.bashrc\n";
    print B "conda activate mypython2\n";
    print B "cd $rstD\n";
    print B "/users/PYS0226/pg123/bin/kraken2 --db /fs/project/PYS0226/database/kraken/fungi2019DB --threads 28 --report $rstD/$a.report  --use-mpa-style $dir/$a.fastq  1>$rstD/$a.kraken 2>$rstD/$a.err\n";

    print B "conda deactivate\n";
    close B;
    print "qsub OSC.MF.$count\n";
}
close A;
